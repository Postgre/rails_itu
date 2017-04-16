'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.interviews.list', {

      url: '',
      templateUrl: appSettings.appPaths.features + '/candidate/interviews/templates/list.html',

      resolve: {
        interviews: ['modelize', function (modelize) {
          return modelize.one('/candidate').many('interviews').all().$future;
        }]
      },

      controllerAs: 'listCtrl',

      controller: ['$scope', 'interviews', function ($scope, interviews) {
        $scope.interviews = interviews;
      }]

    });

  }]);
