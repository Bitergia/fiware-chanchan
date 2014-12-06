'use strict';

angular.module('chanchanApp.manualPublish', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/manualPublish', {
    templateUrl: 'manualPublish/manualPublish.html',
    controller: 'ManualPublishCtrl'
  });
}])

.controller('ManualPublishCtrl', ['$scope', '$http', 'GlobalContextService', function($scope, $http, Context) {
    $scope.orgs_datasets = {};

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
