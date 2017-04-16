'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.resume.skills', {
        abstract: true,
        url: '/resume/skills',
        template: appSettings.passthroughTemplate,
        breadcrumb: {
          label: 'Skills',
          stateRef: 'candidate.resume.skills.edit'
        }
      });

  }]);
