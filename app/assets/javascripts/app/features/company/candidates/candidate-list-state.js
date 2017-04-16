'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.candidates.list', {
      abstract: true,
      url: '',
      templateUrl: appSettings.appPaths.features + '/company/candidates/templates/list.html'
    });

  }]);
