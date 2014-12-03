'use strict';

angular.module('chanchanApp.auth', ['ngRoute', 'ngCookies'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/login', {
    templateUrl: 'auth/login.html',
    controller: 'AuthCtrl'
  });
}])

.controller('AuthCtrl', ['$scope', '$http', '$cookies', function($scope, $http, $cookies) {

    var ses = $cookies.ses;

    // Use login, password and app to get auth_token from IDM server
    // The app is registered in an organization
    $scope.user = "user";
    $scope.password = "password";
    $scope.organizations = ["org1","org2"]; // Will be used the app for this org

}]);
