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
    $scope.listDevices = function() {
        var url = Context.idas()+'/devices';
 
        console.log(url);
        $http({method:'GET',url:url})
        .success(function(data, status, headers, config) {
            if (data.errno != undefined && data.errno == "ECONNREFUSED") {
                $scope.error = "Can not connect to IDAS";
            } else {
                console.log("Devices: " + data);
            }
            $scope.devices = convert_devices(data.devices);
        })
        .error(function(data,status,headers,config){
            $scope.error = "error";
            console.log(data);
        });
    };

    $scope.createDevice = function() {
        // Add 0 temperature to the new device
        $scope.device_new = true;
        $scope.updateTemperature();
    };

    $scope.updateTemperature = function() {
        var url = Context.idas()+'/devices/'+$scope.device;
        url += '/temperature/'+$scope.new_temperature;

        if ($scope.device_new) {
            url = Context.idas()+'/devices/'+$scope.new_device;
            url += '/temperature/'+Context.initial_temp();
        };

        console.log(url);
        $http({method:'POST',url:url})
        .success(function(data, status, headers, config) {
            if (data.errno != undefined && data.errno == "ECONNREFUSED") {
                $scope.error = "Can not connect to IDAS";
            } else {
                console.log("Updated temperature: " + $scope.new_temperature);
                console.log(data);
            }
            $scope.listDevices();
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

    function convert_devices(devices_raw) {
        // Transform devices IDAS format to be managed easily in Angular
        var devices = [];
        angular.forEach(devices_raw, function (device) {
            devices.push(device.device_id);
        });
        return devices;
    }

    $scope.init_view = function() {
        $scope.listDevices();
        $scope.reset_view();
        $scope.org_selected = {name:""};
        var devices_raw = [
            {"device_id":"c4:8e:8f:f4:38:2b:Temp_1"},
            {"device_id":"d2"},
            {"device_id":"d3"}];
        $scope.devices = convert_devices(devices_raw);
        $scope.organizations = Context.organizations();
    };

    $scope.init_view();

}]);
