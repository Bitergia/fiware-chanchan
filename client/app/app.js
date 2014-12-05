'use strict';

// Declare app level module which depends on views, and components
var app = angular.module('chanchanApp', [
  'ngRoute',
  'ui.bootstrap',
  'chanchanApp.auth',
  'chanchanApp.ckan',
  'chanchanApp.orion',
  'chanchanApp.version'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.otherwise({redirectTo: '/login'});
}]);

// Check login before going to any route
app.run(function($rootScope, $location) {
    $rootScope.$on( "$routeChangeStart", function(event, next, current) {
      if ($rootScope.loggedInUser == null) {
        // no logged user, redirect to /login
        if ( next.templateUrl === "auth/login.html") {
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

    // ORION CONFIG
    // var orion_url ='http://chanchan.server/api/orion/contexts';
    var orion_url ='http://chanchan.server:3000/api/orion/contexts';
    // var orion_pep_url ='http://chanchan.server/api/orion-pep/contexts';
    var orion_pep_url ='http://chanchan.server:3000/api/orion-pep/contexts';

    // CKAN CONFIG
    // var ckan_url = 'http://chanchan.server/api/ckan';
    var ckan_url ='http://chanchan.server:3000/api/ckan';

    var organizations = {"org1": {
                                "name":"org1",
                                "id":"4",
                                "secret":"86212b0096f190047cc321ef021ca7649b8ef0bc5da1c689f588512c62504d3152ff6ea2b80919de9ad3489c647cee4c8c250fc6eeef9a78c425a595064401d3",
                            },
                            "org2": {
                                "name":"org2",
                                "id":"3",
                                "secret":"60236d3eb659b8ad3259658ed6b3a2c85dede8c87110e8e2e81dab267cfb5db59d900ec6e00b7aab482a9b7d4b95b1e88096c1b6777a3417c34a325eef005678",
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
