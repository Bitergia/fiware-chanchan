'use strict';

angular.module('chanchanApp.manualPublish', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/manualPublish', {
    templateUrl: 'manualPublish/manualPublish.html',
    controller: 'ManualPublishCtrl'
  });
}])

.controller('ManualPublishCtrl', ['$scope', '$http', 'GlobalContextService', function($scope, $http, Context) {
    $scope.createContext = function(org_name) {
        console.log(Context.orion()+'/contexts/'+org_name+'/'+$scope['context_name_'+org_name]);
        $http.post(Context.orion()+'/contexts/'+org_name+'/'+$scope['context_name_'+org_name]).success(function(data) {
            alert("Created context for " + data);
        });
    };

    $scope.updateTemperature = function(org_name) {
        var url = Context.orion()+'/contexts/'+org_name+'/'+$scope['context_temperature_'+org_name]+'/'+$scope['temperature_'+org_name];
        console.log(url);
        $http.post(url).success(function(data) {
            alert("Update context with " + data);
        });
    };

    $scope.orgs_datasets = {};
    $scope.context_name_org1 = "testorg1";
    $scope.temperature_org1 = "7.6";
    $scope.context_temperature_org1 = "testorg1";

    angular.forEach(Context.orgs(), function(value, org_name) {
        $scope.orgs_datasets[org_name] = {"datasets":[],"resources":[]};
        $http.get(Context.ckan()+'/organization/'+org_name).success(function(data) {
            angular.forEach(data.result.packages, function(dataset, key) {
                $scope.orgs_datasets[org_name].datasets.push(dataset.name);
                angular.forEach(dataset.resources, function(resource, key) {
                    var resource_data = {};
                    $http.get(Context.ckan()+'/resource/'+resource.id).success(function(resource_values) {
                        resource_data.values = resource_values.result.records;
                        resource_data.name = resource.name + " (" + dataset.name  +")";
                        $scope.orgs_datasets[org_name].resources.push(resource_data);
                    });
                });
            });
        });
    });

    $scope.orgs = Context.orgs();
}]);
