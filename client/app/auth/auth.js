'use strict';

angular.module('chanchanApp.auth', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/login', {
    templateUrl: 'auth/login.html',
    controller: 'AuthCtrl'
  });
}])

.controller('AuthCtrl', ['$scope', '$http', function($scope, $http) {

    // Use login, password and app to get auth_token from IDM server
    // The app is registered in an organization
    $scope.user = "chanchan@idm.server";
    $scope.password = "ccadmin";
    $scope.organizations = ["org1","org2"]; // Will be used the app for this org

   if ($scope.user_data !== undefined) {
	$location.path("/ckan");
   }

    $scope.auth = function() {
        var app_org2_secret = "60236d3eb659b8ad3259658ed6b3a2c85dede8c87110e8e2e81dab267cfb5db59d900ec6e00b7aab482a9b7d4b95b1e88096c1b6777a3417c34a325eef005678";
        var app_org2_id = '3';
        var app_org1_secret = "86212b0096f190047cc321ef021ca7649b8ef0bc5da1c689f588512c62504d3152ff6ea2b80919de9ad3489c647cee4c8c250fc6eeef9a78c425a595064401d3";
        var app_org1_id = '4';
        var data =  'grant_type=password';
        data += '&username=chanchan@idm.server';
        data += '&password=ccadmin';

	    if ($scope.organization === "org1") {
            data += '&client_id='+app_org1_id;
            data += '&client_secret='+app_org1_secret;
	    } else if ($scope.organization === "org2") {
            data += '&client_id='+app_org2_id;
            data += '&client_secret='+app_org2_secret;
        }

        var url = "https://idm.server";
        var oauth_token = "oauth2/token";
        var user_roles = "user";


        $http({method:'POST',url:url+"/"+oauth_token,data:data, headers: {'Content-Type': 'application/x-www-form-urlencoded'}})
        .success(function(data,status,headers,config){
            $http({method:'GET',url:url+"/"+user_roles+"?access_token="+data.access_token})
            .success(function(data,status,headers,config){
               $scope.user_data =  data;
               console.log(data);
	        });
        }).
        error(function(data,status,headers,config){
          console.log(data)
        });
    };

}]);
