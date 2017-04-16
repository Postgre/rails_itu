'use strict';

angular.module('bridge.site', [
  'angular-loading-bar',
  'ui.router',
  'bridge', // Anything common 'bridge' module contains
  'bridge.resources'
]);

angular.module('bridge.site')

  .config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
    function ($stateProvider, $urlRouterProvider, $locationProvider) {
      return $locationProvider.hashPrefix("!");
    }])

  .run(['$rootScope', 'currentUser', function ($rootScope, currentUser) {
    $rootScope.currentUser = currentUser;
  }]);

