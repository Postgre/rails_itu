'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.jobs', {
        abstract: true,
        url: '/jobs',
        template: appSettings.passthroughTemplate,

        breadcrumb: {
          label: 'Jobs',
          stateRef: 'candidate.jobs.list'
        }
      });

  }]);
