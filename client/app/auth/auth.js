'use strict';

angular.module('chanchanApp.auth', ['ngRoute', 'ngCookies'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/login', {
    templateUrl: 'auth/login.html',
    controller: 'AuthCtrl'
  });
}])

.controller('AuthCtrl', ['$scope', '$http', '$cookies', function($scope, $http, $cookies) {

    var ses = $cookies.ses;

    // Use login, password and app to get auth_token from IDM server
    // The app is registered in an organization
    $scope.user = "user";
    $scope.password = "password";
    $scope.organizations = ["org1","org2"]; // Will be used the app for this org
    $scope.auth = function() {
        // curl --insecure -i -X POST -H "Content-Type: application/x-www-form-urlencoded" https://idm.server/oauth2/token 
        // -d 'grant_type=password&username=chanchan@idm.server&password=ccadmin&client_id=2&client_secret=6a928e79291c04042271fcf06edc20ffa15f2a2bd18ef332a7d5b2a2fcc3368149722447995cb68d0c94aca5acb82e37d1b269a36530db0d7b2a9cdfd51cbfa5'

        var formData = {
            'grant_type' : "password",
            'username' : $scope.user,
            'password' : $scope.password,
            'client_id' : 2,
            'client_secret' : "6a928e79291c04042271fcf06edc20ffa15f2a2bd18ef332a7d5b2a2fcc3368149722447995cb68d0c94aca5acb82e37d1b269a36530db0d7b2a9cdfd51cbfa5"
        };

        var jdata = JSON.stringify(formData);
        jdata = 'grant_type=password&username=chanchan@idm.server&password=ccadmin&client_id=2&client_secret=6a928e79291c04042271fcf06edc20ffa15f2a2bd18ef332a7d5b2a2fcc3368149722447995cb68d0c94aca5acb82e37d1b269a36530db0d7b2a9cdfd51cbfa5';
        var url = "https://idm.server";
        var oauth_token = "oauth2/token";


        $http({method:'POST',url:url+"/"+oauth_token,data:jdata})
        .success(function(data,status,headers,config){
                  console.log(data);
        }).
        error(function(data,status,headers,config){

          console.log(data)

        });
    };

}]);
