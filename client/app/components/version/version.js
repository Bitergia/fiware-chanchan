'use strict';

angular.module('chanchanApp.version', [
  'chanchanApp.version.interpolate-filter',
  'chanchanApp.version.version-directive'
])

.value('version', '0.1');
