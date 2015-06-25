'use strict';

angular.module('chanchanApp.santander', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/santander', {
    templateUrl: 'santander/santander.html',
    controller: 'SantanderCtrl'
  });
}])

.controller('SantanderCtrl', ['$scope', '$http', '$timeout', 'GlobalContextService', function($scope, $http, $timeout, Context) {
    $scope.createContext = function(org_name) {
        console.log(Context.orion()+'/contexts/'+org_name+'/'+$scope.orgs[org_name].context_new);
        $http.post(Context.orion()+'/contexts/'+org_name+'/'+$scope.orgs[org_name].context_new).success(function(data) {
            // Add a first context update so CKAN entity is created
            $scope.initialContext(org_name, $scope.orgs[org_name].context_new);
            console.log("Created context.");
            // $scope.update_ckan();
        });
    };

    $scope.initialContext = function(org_name, context) {
        if (context == undefined) {
            // FirstEntity-ent1  org1  org1_room_dataset_1
            // Working always with the FirstEntity
            context = $scope.orgs[org_name].context.split("  ")[0];
            context = context.split("-")[1];
        }
        var url = Context.orion()+'/contexts/'+org_name+'/'+context+'/init';
        console.log(url);
        $http.post(url).success(function(data) {
            console.log("Updated context.");
            $timeout($scope.update_ckan, 1000);
        });
    };

    $scope.update_ckan = function() {
      var org_name = $scope.org_selected;
      $http.get(Context.ckan()+'/organization/'+org_name).success(function(data) {
          $scope.orgs_entities = {};
          $scope.orgs_datasets = {};
          angular.forEach(data.result.packages, function(dataset, key) {
              $scope.orgs_datasets[org_name] = {};
              $scope.orgs_entities[org_name] = [];
              $scope.orgs_datasets[org_name][dataset.name] = {'name':dataset.name, 'resources' : []};
              angular.forEach(dataset.resources, function(resource, key) {
                  $scope.orgs_entities[org_name].push(resource.name+ "  " + org_name +"  " + dataset.name);
                  var resource_data = {};
                  $http.get(Context.ckan()+'/resource/'+resource.id).success(function(resource_values) {
                      resource_data.name = resource.name;
                      resource_data.values = resource_values.result.records;
                      $scope.orgs_datasets[org_name][dataset.name]['resources'].push(resource_data);
                  });
              });
          });
          console.log("CKAN data updated.");
      });
    };

    $scope.update_sensors = function(org_name, sensor_type) {
        $scope.sensors = [];
        if (org_name === undefined) {org_name = $scope.org_selected;}
        if (sensor_type === undefined) {sensor_type = $scope.feeders[$scope.feeder_selected].type;}
        var headers = {"x-auth-token":$scope.filabs_access_token};
        console.log("Geeting sensors data ...");
        $http({method:'GET',url:Context.orion()+'/sensors/'+org_name+"/"+sensor_type,headers:headers})
        .success(function(data) {
            console.log(data);
            if (data == "Error in IDM communication") {
                $scope.error = data;
            } else if (typeof(data) == "string" && data.indexOf("Error: connect ECONNREFUSED")>-1) {
                $scope.error = "FIWARE Labs Orion connection refused";
            }
            $scope.sensors = data.contextResponses;
        });
    };


    $scope.auth_filabs = function() {
        var url = Context.filabs()+"/auth/";
        $scope.logging = true;
        $http({method:'GET',url:url+$scope.user+"&"+$scope.password})
        .success(function(data, status, headers, config) {
            $scope.filabs_access_token = data;
            Context.access_token_filabs(data);
            $scope.auth_result = 'ok';
            console.log($scope.filabs_access_token);
            $scope.update_sensors($scope.org_selected, $scope.feeders[$scope.feeder_selected].type);
            $scope.update_ckan();
            $scope.logging = false;
        })
        .error(function(data, status, headers, config) {
            $scope.auth_result = 'error';
            $scope.error_msg = data;
            $scope.logging = false;
        });
    };

    $scope.publish_sensors = function() {
        var all_sensors = {
            "contextElements": [],
            "updateAction": "APPEND"
        };

        angular.forEach($scope.sensors, function(sensor, key) {
            var context = sensor.contextElement;
            var data = {
                "type": context.type,
                "isPattern": context.isPattern,
                "id": context.id,
            };
            data.attributes = [];
            angular.forEach(context.attributes, function(att, key) {
                data.attributes.push({
                        "name": att.name,
                        "type": att.type,
                        "value": att.value
                });
            });
            all_sensors.contextElements.push(data);
        });
        console.log(all_sensors);

        // Publish now in Orion. Support also Orion PEP.
        var url;
        // Context.use_pep(false);
        var headers;
        if (Context.use_pep()) {
            url = Context.orion_pep()+'/entities/'+$scope.org_selected;
            headers = {
                "x-auth-token": Context.access_token_pep(),
                "Content-Type": 'application/json'
            };

        } else {
            url = Context.orion()+'/entities/'+$scope.org_selected;
            headers = {
                "Content-Type": 'application/json'
            };
        }

        console.log(url);

        all_sensors = JSON.stringify(all_sensors);
        $http({method:'POST',url:url, data:all_sensors, headers: headers})
        .success(function(data, status, headers, config) {
            if (data.errno != undefined && data.errno == "ECONNREFUSED") {
                $scope.error = "Can not connect to Orion PEP";
            } else if (data.message != undefined && data.message == "Access forbidden") {
                $scope.error = "Orion PEP: Access forbidden.";
            } else if (data.message != undefined && data.message == "Proxy authentication was rejected with code: 401") {
                $scope.error = data.message;
            } else {
                console.log("Updated context.");
                $timeout($scope.update_ckan, 3000);
            }
        })
        .error(function(data,status,headers,config){
            console.log("Error in Update entities " + data);
            $scope.error = data;
        });
    };

    $scope.filterByName = function(resource) {
        if ($scope.ckan_sensor_name === undefined) {return true;}
        return (resource.name.indexOf($scope.ckan_sensor_name) !== -1);
    };

    $scope.feeders = {
            "sound":{
                name: "sound",
                type: "santander:soundacc"
            }
    };

    $scope.orgs_datasets = undefined;
    $scope.orgs_entities = undefined;
    $scope.org_selected = "santander";
    $scope.feeder_selected = "sound";
    $scope.filabs_access_token = Context.access_token_filabs();
    if ($scope.filabs_access_token != '') {
        $scope.update_sensors($scope.org_selected, $scope.feeders[$scope.feeder_selected].type);
        $scope.update_ckan();
    }
    $scope.logging = false;
    $scope.auth_result = '';
}]);
