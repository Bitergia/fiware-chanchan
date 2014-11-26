'use strict';

// Declare app level module which depends on views, and components
angular.module('chanchanApp', [
  'ngRoute',
  'ui.bootstrap',
  'chanchanApp.ckan',
  'chanchanApp.orion',
  'chanchanApp.version'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.otherwise({redirectTo: '/ckan'});
}]);

angular.module('chanchanApp').controller('DropdownCtrl', function ($scope, $log) {
$scope.items = [
                {type:"fa-user",value:"Profile"},
                {type:"fa-envelope",value:"Inbox"},
                {type:"fa-gear",value:"Settings"},
                {type:"fa-power-off",value:"Log Out"}
];

$scope.status = {
  isopen: false
};

$scope.toggled = function(open) {
  $log.log('Dropdown is now: ', open);
};

$scope.toggleDropdown = function($event) {
      $event.preventDefault();
      $event.stopPropagation();
      $scope.status.isopen = !$scope.status.isopen;
    };
});
