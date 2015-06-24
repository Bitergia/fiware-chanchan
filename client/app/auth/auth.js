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
    $scope.user = 'user0@';
    if (GlobalContextService.hosts() !== undefined) {
        $scope.user += GlobalContextService.hosts().idm_host_docker_image;
    }
    // Now test.com always
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
        data +=    '&organization='+$scope.organization;

        var org_data = GlobalContextService.organizations()[$scope.organization];

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
                {type:"fa-building",value:$scope.organization},
                {type:"fa-check",value:rol_names}
            ];
            $location.path("/manualPublish");
            console.log(data);
        }).
        error(function(data,status,headers,config){
          $scope.auth_result = "error";
          console.log(data);
        });
    };
}]);
