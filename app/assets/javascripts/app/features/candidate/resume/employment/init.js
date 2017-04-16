'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.resume.employment', {
        abstract: true,
        url: '/resume/employment',
        template: appSettings.passthroughTemplate,
        breadcrumb: {
          label: 'Employment',
          stateRef: 'candidate.resume.employment.list'
        }
      });

  }]);
