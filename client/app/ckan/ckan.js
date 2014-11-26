'use strict';

angular.module('chanchanApp.ckan', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/ckan', {
    templateUrl: 'ckan/ckan.html',
    controller: 'CKANCtrl'
  });
}])

.controller('CKANCtrl', [function() {

}]);
