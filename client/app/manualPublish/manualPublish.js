'use strict';

angular.module('chanchanApp.manualPublish', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/manualPublish', {
    templateUrl: 'manualPublish/manualPublish.html',
    controller: 'ManualPublishCtrl'
  });
}])

.controller('ManualPublishCtrl', ['$scope', '$http', 'GlobalContextService', function($scope, $http, Context) {
    $scope.CKAN = "CKAN dataset data";
    $scope.orgs = Context.orgs();
}]);
