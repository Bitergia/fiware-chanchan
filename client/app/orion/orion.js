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
    $http.get('http://chanchan.server/api/orion/contexts').success(function(data) {
        $scope.contexts = data.contextResponses;
    });
}]);
