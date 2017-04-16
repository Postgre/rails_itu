'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.interviews.list', {

      url: '',
      templateUrl: appSettings.appPaths.features + '/company/interviews/templates/list.html',
      controllerAs: 'listCtrl',

      controller: ['$scope', 'companyId', 'modelize', 'humanizedMsg',
        function ($scope, companyId, modelize, humanizedMsg) {
          $scope.interviews = modelize.one('company', companyId).many('interviews').all().$future;
        }]

    });

  }]);
