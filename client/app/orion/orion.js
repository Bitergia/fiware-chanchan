'use strict';

angular.module('chanchanApp.orion', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/orion', {
    templateUrl: 'orion/orion.html',
    controller: 'OrionCtrl'
  });
}])

.controller('OrionCtrl', ['$scope', '$http', 'GlobalContextService', function($scope, $http, Context) {
    $scope.app_id = Context.app_id();
    $scope.org_id = Context.org_id();
    $scope.access_token = Context.access_token();
    console.log(Context.orion());
    $http.get(Context.orion()).success(function(data) {
        if (data.status !== undefined) {
            $scope.error = data.status;
        } else {
            $scope.contexts = data.contextResponses;
        }
    });
    console.log(Context.orion_pep());
    $http.get(Context.orion_pep()).success(function(data) {
        if (data.status !== undefined) {
            $scope.error_pep = data.status;
        } else {
            $scope.contexts_pep = data.contextResponses;
        }
    });
}]);
