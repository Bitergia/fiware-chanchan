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
          $location.path("/login");
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

    var organizations = {"organization_a": {
                                "name":"Organization A",
                                "id":"2",
                                "secret":"f9f2602f08650eebb101d42888936d7276c418b7c1c83c3bf28f991cb4cdc3dbeea30588b6a8b90bb6c274e50efd02c74c538fe33895a8bd0d58175b6229f28b",
                            },
                         "organization_b": {
                                "name":"Organization B",
                                "id":"3",
                                "secret":"47ae9770c13aa1a9607a9ba164f4ebb3bdce2a2b2653ef1a3dcd23347a3c245aaa59a62e848589456e0ceae06fea5b8cf2769de167f30ec9c219af30fb4d65b6",
                            }};
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
