'use strict';

angular.module('chanchanApp.autoPublish', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/autoPublish', {
    templateUrl: 'autoPublish/autoPublish.html',
    controller: 'AutoPublishCtrl'
  });
}])

.controller('AutoPublishCtrl', ['$scope', '$http', '$timeout', 'GlobalContextService', function($scope, $http, $timeout, Context) {
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
      angular.forEach($scope.orgs, function(value, org_name) {
          $scope.orgs_datasets[org_name] = {};
          $scope.orgs_entities[org_name] = [];
          $http.get(Context.ckan()+'/organization/'+org_name).success(function(data) {
              angular.forEach(data.result.packages, function(dataset, key) {
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
          });
      });
      console.log("CKAN data updated.");
    };

    $scope.feeders = {
            "twitter":{
                name: "twitter trends"
            },
            "santander":{
                name: "santander lights"
            },
            "madrid":{
                name: "madrid traffic"
            }
    };

    $scope.orgs_datasets = {};
    $scope.orgs_entities = {};
    $scope.org_selected = "";
    $scope.update_ckan();
}]);
