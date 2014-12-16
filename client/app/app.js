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
app.run(function($rootScope, $location, $http) {
    $rootScope.$on("$routeChangeStart", function(event, next, current) {
      if ($rootScope.loggedInUser == null) {
        // no logged user, redirect to /login
        if (next.templateUrl === "auth/login.html") {
        } else {
          $location.path("/login");
        }
      }
    });
    // Load orgs data
    $http.get("orgs.json").success(function(data) {
        $rootScope.organizations = data;
    });
});

// GlobalContext service to share data between controllers
// TODO: just use rootScope?
app.factory('GlobalContextService', function() {
    var access_token_val, access_token_filabs_val = '', app_id_val, org_id_val, roles_val;
    var use_pep_val = true;

    // ORION AND CKAN CONFIG
    var base_url = '';
    var orion_url = base_url + '/api/orion';
    var orion_pep_url = base_url + '/api/orion-pep';
    var ckan_url = base_url + '/api/ckan';
    // Development config
    // var orion_url ='http://chanchan.server:3000/api/orion';
    // var orion_pep_url ='http://chanchan.server:3000/api/orion-pep';
    // var ckan_url ='http://chanchan.server:3000/api/ckan';

  return {
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
    use_pep: function(val) {
        if (val !== undefined) {use_pep_val = val;}
        return use_pep_val;
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
