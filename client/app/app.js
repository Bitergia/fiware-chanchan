'use strict';

// Declare app level module which depends on views, and components
var app = angular.module('chanchanApp', [
  'ngRoute',
  'ui.bootstrap',
  'chanchanApp.auth',
  'chanchanApp.ckan',
  'chanchanApp.config',
  'chanchanApp.manualIDAS',
  'chanchanApp.manualPublish',
  'chanchanApp.santander',
  'chanchanApp.orion',
  'chanchanApp.version'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.otherwise({redirectTo: '/login'});
}]);

// Check config and login before going to any route
app.run(function($rootScope, $location, $http, GlobalContextService) {
    $rootScope.$on("$routeChangeStart", function(event, next, current) {
        return;
        if (next.templateUrl === "config/config.html") {
        } else {
          if ($rootScope.loggedInUser == null) {
            if (next.templateUrl === "auth/login.html")  {
            } else {
                // no logged user, config ok, redirect to /login
                $location.path("/login");
            }
          }
        }
    });
    // Load orgs data
    $http.get("orgs.json").
        success(function(data) {
            // organizations available in IDM
            GlobalContextService.organizations(data);
        }).
        error(function(data, status, headers, config) {
            $location.path("/config");
        });
    $http.get("hosts.json").
        success(function(data) {
            // hostnames for idm and chanchan services
            GlobalContextService.hosts(data);
        }).
        error(function(data, status, headers, config) {
            $location.path("/config");
        });
});

// GlobalContext service to share data between controllers
app.factory('GlobalContextService', ['$rootScope','$http',function($rootScope, $http) {
    var access_token_val, access_token_filabs_val = '', app_id_val, org_id_val, org_name_val, roles_val;
    var use_pep_val = true, hosts_val, organizations_val;

    // ORION AND CKAN AND FILABS CONFIG
    // var base_url = 'http://'+hosts.chanchan;
    var base_url = '';
    var orion_url = base_url + '/api/orion';
    var orion_pep_url = base_url + '/api/orion-pep';
    var ckan_url = base_url + '/api/ckan';
    var filabs_url = base_url + '/api/filabs';
    var idas_url = base_url + '/api/idas';
    var initial_temp = '00'; // Initial temp for a new device

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
    org_name: function(val) {
        if (val !== undefined) {org_name_val = val;}
        return org_name_val;
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
    },
    filabs: function(val) {
        if (val !== undefined) {filabs_url = val;}
        return filabs_url;
    },
    hosts: function(val) {
        if (val !== undefined) {hosts_val = val;}
        return hosts_val;
    },
    organizations: function(val) {
        if (val !== undefined) {organizations_val = val;}
        return organizations_val;
    },
    idas: function(val) {
        if (val !== undefined) {idas_url = val;}
        return idas_url;
    },
    initial_temp: function(val) {
        if (val !== undefined) {initial_temp = val;}
        return initial_temp;
    }
  };
}]);

angular.module('chanchanApp').controller('DropdownCtrl', 
        ['$scope', '$rootScope', '$log', function ($scope, $rootScope, $log) {
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
