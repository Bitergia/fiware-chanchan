'use strict';

angular.module('chanchanApp.auth', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/login', {
    templateUrl: 'auth/login.html',
    controller: 'AuthCtrl'
  });
}])

.controller('AuthCtrl', ['$scope', '$location', '$http', 'GlobalContextService', function($scope, $location, $http, GlobalContextService) {

    // Use login, password and app to get auth_token from IDM server
    // The app is registered in an organization
    $scope.user = "chanchan@idm.server";
    $scope.password = "ccadmin";
    // The id and secret comes from IDM application data in the org
    
    $scope.organizations = GlobalContextService.orgs();

    $scope.auth = function() {
        var data = 'grant_type=password';
        data +=    '&username='+$scope.user;
        data +=    '&password='+$scope.password;

        var org_data = $scope.organizations[$scope.organization];
        data += '&client_id='+org_data.id;
        data += '&client_secret='+org_data.secret;

        var url = "https://idm.server";
        var oauth_token = "oauth2/token";
        var user_roles = "user";


        $http({method:'POST',url:url+"/"+oauth_token,data:data, headers: {'Content-Type': 'application/x-www-form-urlencoded'}})
        .success(function(data,status,headers,config){
            var access_token = data.access_token;
            $http({method:'GET',url:url+"/"+user_roles+"?access_token="+data.access_token})
            .success(function(data,status,headers,config){
               $scope.user_data =  data;
               $scope.auth_result = "ok";
               if (data.organizations) {
                    // Find the organization roles
                    var roles = [];
                    angular.forEach(data.organizations, function(value, key) {
                        if (value.displayName === $scope.organization) {
                            GlobalContextService.roles(roles);
                            GlobalContextService.org_id(value.id);
                            GlobalContextService.app_id(data.app_id);
                            GlobalContextService.access_token(access_token);
                            roles = value.roles;
                            $scope.org_id = value.id;
                            $scope.app_id = data.app_id;
                            return false;
                        }
                    }, roles);
                    $scope.roles = roles;
                    $location.path("/orion");
               }
               console.log(data);
	        });
        }).
        error(function(data,status,headers,config){
          $scope.auth_result = "error";
          console.log(data)
        });
    };

}]);
