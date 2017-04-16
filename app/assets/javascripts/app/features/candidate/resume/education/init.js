'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.resume.education', {
        abstract: true,
        url: '/resume/education',
        template: appSettings.passthroughTemplate,
        breadcrumb: {
          label: 'Education',
          stateRef: 'candidate.resume.education.list'
        }
      });

  }]);
