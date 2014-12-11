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
    var access_token_val, app_id_val, org_id_val, roles_val;

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
                                "secret":"22903cea1159501528fe24c27cfbe832ab793de0fecaf62b4d3fb1fa6ee88b9851edbb4fae8709f0e1e1dd6e67ac79411eb24a69bd44b7b2592f7d149ba8c711",
                            },
                         "org2": {
                                "name":"org2",
                                "id":"3",
                                "secret":"00fd36ea38e5ed87254f64479f7776621f05d62316a22bee55b0759e88ec70352be3ba14388d01d30288eae9ebdf739ec13aa6f4b741cd6dddb7c1c194e18046",
                            }};
  return {
    orgs: function() {
      return organizations;
    },
    access_token: function(val) {
      if (val !== undefined) {access_token_val = val;}
      return access_token_val;
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
