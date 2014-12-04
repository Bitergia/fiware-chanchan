'use strict';

angular.module('chanchanApp.ckan', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/ckan', {
    templateUrl: 'ckan/ckan.html',
    controller: 'CKANCtrl'
  });
}])

.controller('CKANCtrl', ['$scope', '$http', 'GlobalContextService', function($scope, $http, Context) {
    $http.get(Context.ckan()+'/datasets').success(function(data) {
        $scope.datasets = data.result;
    });
    $http.get(Context.ckan()+'/organizations').success(function(data) {
        $scope.organizations = data.result;
    });
}]);
