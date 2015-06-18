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

    function convert_devices(devices_raw) {
        // Transform devices IDAS format to be managed easily in Angular
        var devices = [];
        angular.forEach(devices_raw, function (device) {
            devices.push(device.device_id);
        });
        return devices;
    }

    function convert_history(history_raw) {
        // Convert devices history to a simpler format to be shown in Angular
        var history = {};
        angular.forEach(history_raw, function (device_temps) {
            history[device_temps[0].entityId] = [];
            angular.forEach(device_temps, function(temp_data) {
                history[device_temps[0].entityId].push(temp_data);
            });
        });
        $scope.history = history;
    }

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
            // Wait a bit so the event reaches cygnus and mysql
            $timeout($scope.getHistory, 1000);
        })
        .error(function(data,status,headers,config){
            $scope.error = "error";
            console.log(data);
        });
    };

    $scope.getHistory = function() {
        var url = Context.idas()+'/history';
        $http({method:'GET',url:url})
        .success(function(data, status, headers, config) {
            if (data.errno != undefined && data.errno == "ECONNREFUSED") {
                $scope.error = "Can not connect to IDAS";
            } else {
                convert_history(data);
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
        $scope.listDevices();
        $scope.getHistory();
        $scope.reset_view();
        $scope.org_selected = {name:""};
        var devices_raw = [
            {"device_id":"c4:8e:8f:f4:38:2b:Temp_1"},
            {"device_id":"d2"},
            {"device_id":"d3"}];
        $scope.devices = convert_devices(devices_raw);
    };

    $scope.init_view();

}]);
