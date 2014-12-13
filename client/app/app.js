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
    var orion_url ='http://chanchan.server/api/orion';
    var orion_pep_url ='http://chanchan.server/api/orion-pep';
    var ckan_url = 'http://chanchan.server/api/ckan';
    // Development config
    // var orion_url ='http://chanchan.server:3000/api/orion';
    // var orion_pep_url ='http://chanchan.server:3000/api/orion-pep';
    // var ckan_url ='http://chanchan.server:3000/api/ckan';

    var organizations = {"org1": {
                                "name":"org1",
                                "id":"2",
                                "secret":"3a0eb118aab4d813450c52d6efad91abe0354fea02bb959869ab0848ab668b7928ddd23661485c65fb55a53ae01c867cf93a32b10848b237cc663a5f6636317b",
                            },
                         "org2": {
                                "name":"org2",
                                "id":"3",
                                "secret":"b604ba5e9741a85e7da65602624f3e23c133e76c3a7f559cda5cec2a36a3cc835ac3f456226d9e170f68b7f90985709230d20b36608a3c1c2775e5b8a3c181af",
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
