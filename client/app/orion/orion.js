'use strict';

angular.module('chanchanApp.orion', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/orion', {
    templateUrl: 'orion/orion.html',
    controller: 'OrionCtrl'
  });
}])

.controller('OrionCtrl', [function() {

}]);
