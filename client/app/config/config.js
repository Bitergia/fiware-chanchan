'use strict';

angular.module('chanchanApp.config', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/config', {
    templateUrl: 'config/config.html',
    controller: 'ConfigCtrl'
  });
}])

.controller('ConfigCtrl', function() {
    console.log("Config");
});
