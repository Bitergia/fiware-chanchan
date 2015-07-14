'use strict';

angular.module('chanchanApp.auth', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/login', {
    templateUrl: 'auth/login.html',
    controller: 'AuthCtrl'
  });
}])

.controller('AuthCtrl', ['$scope', '$rootScope', '$location', '$http', 'GlobalContextService',
                         function($scope, $rootScope, $location, $http, GlobalContextService) {

    // Use login, password and app to get auth_token from IDM server
    // The app is registered in an organization
    $scope.user = 'user0@test.com';
    $scope.password = 'test';
    // The id and secret comes from IDM application data in the org
    $scope.organizations = {};
    if (GlobalContextService.organizations() !== undefined) {
        $scope.organizations = GlobalContextService.organizations();
    }

    $scope.auth = function() {
        var data = 'username='+$scope.user;
        data +=    '&password='+$scope.password;

        var org_data = GlobalContextService.organizations()[$scope.organization];
        data +=    '&organization='+org_data.name;

        var url = GlobalContextService.idm();
        $scope.auth_result = "process";

        $http({method:'GET',url:url+"/auth"+"/"+data})
        .success(function(data,status,headers,config){
            if (data.error !== undefined) {
                $scope.auth_result = "error";
                console.log(data);
                return;
            }
            var access_token = data.value;
            var access_token = data.token_pep;
            // All the information about the token comes in data.token
            data = data.token;
            $scope.user_data =  data;
            $scope.auth_result = "ok";
            GlobalContextService.access_token(access_token);

            // Find the organization roles
            GlobalContextService.roles(data.roles);
            GlobalContextService.org_name(data.project.name);
            // GlobalContextService.org_id(value.id);
            // GlobalContextService.app_id(data.app_id);
            // $scope.org_id = value.id;
            // $scope.app_id = data.app_id;
            $scope.roles = data.roles;
            var rol_names = "";
            angular.forEach (data.roles,
                   function (value, key) {rol_names+= value.name + ",";});
            rol_names = rol_names.substring(0, rol_names.length -1);
            $rootScope.loggedInUser = true;
            $rootScope.user_name = data.user.name;
            $rootScope.user_profile = [
                {type:"fa-user",value:data.user.id},
                {type:"fa-envelope",value:data.user.name},
                {type:"fa-building",value:data.project.name},
                {type:"fa-gear",value:data.project.name},
                {type:"fa-check",value:rol_names}
            ];
            $location.path("/manualPublish");
            console.log(data);
        }).
        error(function(data,status,headers,config){
          $scope.auth_result = "error";
          console.log(data);
        });

        // We should also get the auth token for PEP
        data =  'username='+$scope.user;
        data += '&password='+$scope.password;

        var app_secret = GlobalContextService.app_secret();
        data += '&client_id='+app_secret.id;
        data += '&client_secret='+app_secret.secret;

        var url = GlobalContextService.idm();
        $scope.auth_result_pep = "process";

        $http({method:'GET',url:url+"/auth_pep"+"/"+data})
        .success(function(data, status, headers, config){
            $scope.auth_result_pep = "ok";
            GlobalContextService.access_token_pep(data.access_token);
        }).
        error(function(data, status, headers, config){
            $scope.auth_result = "error";
            console.log(data);
          });
    };
}]);
