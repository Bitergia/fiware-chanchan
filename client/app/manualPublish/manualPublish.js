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
        var url = Context.orion()+'/contexts/'+org_name+'/'+context+'/'+$scope.org_selected.temperature;
        console.log(url);
        $http.post(url).success(function(data) {
            console.log("Updated context: " + context);
            $scope.orgs_entities[org_name] = undefined;
            $scope.orgs_datasets[org_name] = undefined;
            $timeout($scope.update_ckan, 2000);
        });
    };

    $scope.update_ckan = function() {
      angular.forEach($scope.orgs, function(value, org_name) {
          $scope.orgs_datasets[org_name] = null;
          $scope.orgs_entities[org_name] = null;
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
              }
          });
      });
      console.log("CKAN data updated.");
    };

    $scope.init_view = function() {
        $scope.orgs = Context.orgs();
        $scope.orgs_datasets = {};
        $scope.orgs_entities = {};
        $scope.org_selected = {name:""};
        $scope.error = undefined;
    };

    $scope.init_view();

}]);
