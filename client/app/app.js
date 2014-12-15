'use strict';

// Declare app level module which depends on views, and components
var app = angular.module('chanchanApp', [
  'ngRoute',
  'ui.bootstrap',
  'chanchanApp.auth',
  'chanchanApp.ckan',
  'chanchanApp.manualPublish',
  'chanchanApp.santander',
  'chanchanApp.orion',
  'chanchanApp.version'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.otherwise({redirectTo: '/login'});
}]);

// Check login before going to any route
app.run(function($rootScope, $location) {
    $rootScope.$on("$routeChangeStart", function(event, next, current) {
      if ($rootScope.loggedInUser == null) {
        // no logged user, redirect to /login
        if (next.templateUrl === "auth/login.html") {
        } else {
          // $location.path("/login");
        }
      }
    });
});

// GlobalContext service to share data between controllers
// TODO: just use rootScope?
app.factory('GlobalContextService', function() {
    var access_token_val, access_token_filabs_val = '', app_id_val, org_id_val, roles_val;

    // ORION AND CKAN CONFIG
    var base_url = '';
    var orion_url = base_url + '/api/orion';
    var orion_pep_url = base_url + '/api/orion-pep';
    var ckan_url = base_url + '/api/ckan';
    // Development config
    // var orion_url ='http://chanchan.server:3000/api/orion';
    // var orion_pep_url ='http://chanchan.server:3000/api/orion-pep';
    // var ckan_url ='http://chanchan.server:3000/api/ckan';

    var organizations = {
	"Organization A": {
            "id": "2",
            "name": "Organization A",
            "secret": "0ecf8db63ec7c36d4749b30008640214d4a45555e79115ef8ecdcc30ddc4f5981fddfc7482793a2d407ddf63f49f43aa492eddc5c59d6115b518ee8c639e8df2"
	},
	"Organization B": {
            "id": "3",
            "name": "Organization B",
            "secret": "c90260b803c82b6fdd1cc42ad6dea13fa5dcfc9eded65904ba397ad6acb4cad566a622499f948f3e3fa5d7545474e42de1e9293b37417022edc815daffbbd58c"
	}
    };

  return {
    orgs: function() {
      return organizations;
    },
    access_token: function(val) {
      if (val !== undefined) {access_token_val = val;}
      return access_token_val;
    },
    access_token_filabs: function(val) {
        if (val !== undefined) {access_token_filabs_val = val;}
        return access_token_filabs_val;
      },
    app_id: function(val) {
      if (val !== undefined) {app_id_val = val;}
      return app_id_val;
    },
    org_id: function(val) {
      if (val !== undefined) {org_id_val = val;}
      return org_id_val;
    },
    roles: function(val) {
      if (val !== undefined) {roles_val = val;}
      return roles_val;
    },
    orion: function(val) {
      if (val !== undefined) {orion_url = val;}
      return orion_url;
    },
    orion_pep: function(val) {
      if (val !== undefined) {orion_pep_url = val;}
      return orion_pep_url;
    },
    ckan: function(val) {
      if (val !== undefined) {ckan_url = val;}
      return ckan_url;
    }
  };
});

angular.module('chanchanApp').controller('DropdownCtrl', ['$scope', '$rootScope', '$log', function ($scope, $rootScope, $log) {
    $scope.status = {
        isopen: false
    };

    $scope.toggled = function(open) {
        $log.log('Dropdown is now: ', open);
    };

    $scope.toggleDropdown = function($event) {
      $event.preventDefault();
      $event.stopPropagation();
      $scope.status.isopen = !$scope.status.isopen;
    };
}]);
