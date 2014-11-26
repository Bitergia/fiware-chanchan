'use strict';

angular.module('chanchanApp.orion', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/orion', {
    templateUrl: 'orion/orion.html',
    controller: 'OrionCtrl'
  });
}])

.controller('OrionCtrl', ['$scope', '$http', function($scope, $http) {
    $http.get('http://localhost:3000/api/orion/contexts').success(function(data) {
        $scope.contexts = data.contextResponses;
    });
}]);
