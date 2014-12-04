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
        jdata = 'grant_type=password&username=chanchan@idm.server&password=ccadmin&client_id=2&client_secret=d3d380ec8133e3b71440a0c2aec7797befef0e147b82848dffe207b7ea38a7a6d77c8854246a9853846328bb1db27dafa71ed05708f3e531095e917cd192a840';
        var url = "https://idm.server";
        var oauth_token = "oauth2/token";
        var user_roles = "user";


        $http({method:'POST',url:url+"/"+oauth_token,data:jdata, headers: {'Content-Type': 'application/x-www-form-urlencoded'}})
        .success(function(data,status,headers,config){
            $http({method:'GET',url:url+"/"+user_roles+"?access_token="+data.access_token})
            .success(function(data,status,headers,config){
                console.log(data);
	    });
        }).
        error(function(data,status,headers,config){

          console.log(data)

        });
    };

}]);
