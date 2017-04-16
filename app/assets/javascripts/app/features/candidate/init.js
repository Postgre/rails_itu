'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate', {
        abstract: true,
        url: '/candidate',
        templateUrl: appSettings.appPaths.features + '/candidate/templates/layout.html',

        data: {
          allowRoles: ['candidate']
        }
      });

  }]);
