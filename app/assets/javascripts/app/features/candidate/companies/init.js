'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.companies', {
        abstract: true,
        url: '/companies',
        template: appSettings.passthroughTemplate
      });

  }]);
