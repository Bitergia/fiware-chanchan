'use strict';

angular.module('chanchanApp.ckan', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/ckan', {
    templateUrl: 'ckan/ckan.html',
    controller: 'CKANCtrl'
  });
}])

.controller('CKANCtrl', ['$scope', '$http', function($scope, $http) {
    $http.get('http://localhost:3000/api/ckan/datasets').success(function(data) {
        $scope.datasets = data.result;
    });
    $http.get('http://localhost:3000/api/ckan/organizations').success(function(data) {
        $scope.organizations = data.result;
    });
}]);
