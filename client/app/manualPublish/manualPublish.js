'use strict';

angular.module('chanchanApp.manualPublish', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/manualPublish', {
    templateUrl: 'manualPublish/manualPublish.html',
    controller: 'ManualPublishCtrl'
  });
}])

.controller('ManualPublishCtrl', ['$scope', '$http', '$timeout', 'GlobalContextService', function($scope, $http, $timeout, Context) {
    $scope.createContext = function(org_name) {
        $scope.org_selected.temperature = "-";
        var context = $scope.org_selected.context_new;
        context = "manual:"+context; // Name space for manual measures
        $scope.updateTemperature(org_name, context);
        console.log("Created context: " + context);
        $scope.org_selected.temperature = "";
        $scope.org_selected.context_new = "";
    };

    $scope.updateTemperature = function(org_name, context) {
        if (context == undefined) {
            // FirstEntity-ent1  org1  org1_room_dataset_1
            // Working always with the FirstEntity
            context = $scope.org_selected.context.split("  ")[0];
            context = context.split("-")[0];
        }

        var url;
        // Context.use_pep(false);
        if (Context.use_pep()) {
            url = Context.orion_pep()+'/contexts/'+org_name+'/'+context+'/'+$scope.org_selected.temperature;
        } else {
            url = Context.orion()+'/contexts/'+org_name+'/'+context+'/'+$scope.org_selected.temperature;
        }

        if (Context.use_pep() && Context.roles().length === 0) {
            $scope.roles_error = "You don't have roles for " + $scope.org_selected.name;
            return;
        };

       var headers = {
                "fiware-service": org_name,
                "fiware-servicepath": context,
                "x-auth-token": Context.access_token_pep()
        };

       console.log(url);

        $http({method:'POST',url:url, headers:headers})
        .success(function(data, status, headers, config){
            if (data.errno != undefined && data.errno == "ECONNREFUSED") {
                $scope.error = "Can not connect to Orion PEP";
            } else if (data === "User token not authorized") {
                $scope.error = "Wilma PEP: Access forbidden.";
            } else if (data.orionError) {
                    $scope.error = "Orion error: " + data.orionError;
            } else {
                console.log("Updated context: " + context);
                $scope.orgs_entities[org_name] = undefined;
                $scope.orgs_datasets[org_name] = undefined;
                $timeout($scope.update_ckan, 2000);
            }
        })
        .error(function(data,status,headers,config){
            $scope.error = "error";
            console.log(data);
        });
    };

    $scope.update_ckan = function() {
      angular.forEach(Context.organizations(), function(value, org_name) {
          $scope.reset_view();
          $http.get(Context.ckan()+'/organization/'+org_name).success(function(data) {
              if (data.result === undefined) {
                  // Org not found
                  $scope.error = data.error.message;
              }
              else {
                  $scope.orgs_entities[org_name] = [];
                  $scope.orgs_datasets[org_name] = {};
                  angular.forEach(data.result.packages, function(dataset, key) {
                      $scope.orgs_datasets[org_name][dataset.name] = {'name':dataset.name, 'resources' : []};
                      $http.get(Context.ckan()+'/dataset/'+dataset.id).success(function(resources_res) {
                        var resources = resources_res.result.resources;
                        angular.forEach(resources, function(resource, key) {
                            $scope.orgs_entities[org_name].push(resource.name+ "  " + org_name +"  " + dataset.name);
                            var resource_data = {};
                            $http.get(Context.ckan()+'/resource/'+resource.id).success(function(resource_values) {
                                if (resource_values.success === false) {
                                    console.log(resource_values.error.message);
                                    return;
                                }
                                resource_data.name = resource.name;
                                resource_data.values = resource_values.result.records;
                                $scope.orgs_datasets[org_name][dataset.name]['resources'].push(resource_data);
                            });
                        });
                      });
                  });
              }
          });
      });
      console.log("CKAN data updated.");
    };

    $scope.reset_view = function() {
        $scope.orgs_datasets = {};
        $scope.orgs_entities = {};
        $scope.error = undefined;
    };

    $scope.init_view = function() {
        $scope.reset_view();
        $scope.org_selected = {name:""};
        $scope.organizations = Context.organizations();
    };

    $scope.init_view();

}]);
