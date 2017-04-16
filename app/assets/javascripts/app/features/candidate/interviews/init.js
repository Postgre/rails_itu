'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.interviews', {
        abstract: true,
        url: '/interviews',
        template: appSettings.passthroughTemplate
      });

  }]);
