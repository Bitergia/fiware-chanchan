'use strict';

angular.module('chanchanApp.manualIDAS', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/manualIDAS', {
    templateUrl: 'idas/manualIDAS.html',
    controller: 'ManualIDASCtrl'
  });
}])

.controller('ManualIDASCtrl', ['$scope', '$http', '$timeout',
                               'GlobalContextService', 
                               function($scope, $http, $timeout, Context) {
    $scope.createDevice = function(name) {
        $scope.org_selected.temperature = "-";
        var context = $scope.org_selected.context_new;
        context = "manual:"+context; // Name space for manual measures
        $scope.updateTemperature(org_name, context);
        console.log("Created context: " + context);
        $scope.org_selected.temperature = "";
        $scope.org_selected.context_new = "";
    };

    $scope.updateTemperature = function() {
        var url;
        url  = Context.idas()+'/devices/'+$scope.device;
        url += '/temperature/'+$scope.new_temperature;

        console.log(url);
        $http({method:'POST',url:url})
        .success(function(data, status, headers, config) {
            if (data.errno != undefined && data.errno == "ECONNREFUSED") {
                $scope.error = "Can not connect to IDAS";
            } else {
                console.log("Updated temperature: " + $scope.new_temperature);
            }
        })
        .error(function(data,status,headers,config){
            $scope.error = "error";
            console.log(data);
        });
    };

    $scope.reset_view = function() {
        $scope.orgs_datasets = {};
        $scope.orgs_entities = {};
        $scope.error = undefined;
    };

    $scope.init_view = function() {
        $scope.reset_view();
        $scope.org_selected = {name:""};
        $scope.devices = {"c4:8e:8f:f4:38:2b:Temp_1":"c4:8e:8f:f4:38:2b:Temp_1",
                          "d2":"d2name"};
        $scope.organizations = Context.organizations();
    };

    $scope.init_view();

}]);
