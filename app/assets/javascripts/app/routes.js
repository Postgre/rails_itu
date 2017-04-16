'use strict';

angular.module('bridge')

  .config(['$stateProvider', '$urlRouterProvider', 'appSettings', function ($stateProvider, $urlRouterProvider, appSettings) {
    // Core app states

    // TEMP: Redirect all users to /candidate route assuming they're all candidates
    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('index', {
        url: '/',
        templateUrl: appSettings.appPaths.core + '/templates/index-loading.html',
        controller: ['userRoleDispatcher', function (userRoleDispatcher) {
          userRoleDispatcher.dispatch();
        }]
      });
  }]);
