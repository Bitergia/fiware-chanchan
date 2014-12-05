'use strict';

// Declare app level module which depends on views, and components
var app = angular.module('chanchanApp', [
  'ngRoute',
  'ui.bootstrap',
  'chanchanApp.auth',
  'chanchanApp.ckan',
  'chanchanApp.manualPublish',
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
    var orion_url ='http://chanchan.server/api/orion/contexts';
    var orion_pep_url ='http://chanchan.server/api/orion-pep/contexts';
    var ckan_url = 'http://chanchan.server/api/ckan';
    // Development config
    // var orion_url ='http://chanchan.server:3000/api/orion/contexts';
    // var orion_pep_url ='http://chanchan.server:3000/api/orion-pep/contexts';
    // var ckan_url ='http://chanchan.server:3000/api/ckan';

    var organizations = {"org1": {
                                "name":"org1",
                                "id":"2",
                                "secret":"1138f19d49dda081fd543f5b33ced5859edbc1f45d0322863ad5a136ed0f941ecd83491e12cb09e7ae55d36769b21ae14c4351872b4e3217160565d7092ff45c",
                            },
                         "org2": {
                                "name":"org2",
                                "id":"3",
                                "secret":"ac502a28b454bc71e5642512d48d479e124503f45e10651e6917c2330221d61a98316a37bb13c5e5eb4b4548adbe7d498f2752f9a250a2259e074d70a7bddb2e",
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
