angular.module('templates', []);

// Init app itself and attach some external/core modules
angular.module('bridge.app', [
  'ngAnimate',
  'ngCookies',
  'ngMessages',
  'ui.router',
  'ngExStatecrumbs',
  'ngExModalbox',
  'ngExHumanizedMsg',
  'ngExTopslideErrorMsg',
  'ngExDatepickers',
  'ngExPromiseTracker',
  'textAngular',
  'angular-modelizer',
  'restangular',
  'ui.bootstrap.tpls',
  'ui.bootstrap.dropdown',
  'ui.bootstrap.pagination',
  'ui.bootstrap.typeahead-fixed',
  'mgcrea.ngStrap',
  'ui.select2',
  'angularFileUpload',
  'bridge', // everything attached to universal 'bridge' module
  'templates'
]);

// Global routing settings (should be before routes setup)
angular.module('bridge.app').config(['$locationProvider', function ($locationProvider) {
  // $locationProvider.html5Mode(true);
  $locationProvider.hashPrefix('!');
}]);

