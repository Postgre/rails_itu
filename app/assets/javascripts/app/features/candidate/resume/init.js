'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.resume', {
        abstract: true,
        url: '',
        template: appSettings.passthroughTemplate,
        breadcrumb: {
          label: 'My Resume',
          stateRef: 'candidate.resume.index'
        }
      });

  }]);
