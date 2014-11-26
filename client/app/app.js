'use strict';

// Declare app level module which depends on views, and components
angular.module('chanchanApp', [
  'ngRoute',
  'chanchanApp.ckan',
  'chanchanApp.orion',
  'chanchanApp.version'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.otherwise({redirectTo: '/ckan'});
}]);
