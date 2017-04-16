'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.candidates.resume', {

        url: '/:candidateId/resume',
        templateUrl: appSettings.appPaths.features + '/company/candidates/templates/resume.html',
        breadcrumb: {
          label: 'Resume'
        },

        resolve: {
          candidate: ['modelize', '$stateParams', function (modelize, $stateParams) {
            return modelize.one('candidate', $stateParams.candidateId).get({ params: { jobId: $stateParams.jobId } });
          }]
        },

        controllerAs: 'resumeCtrl',

        controller: ['$scope', '$stateParams', 'candidate', function ($scope, $stateParams, candidate) {
          this.candidate = candidate;

          $scope.invite = function () {
            // TODO
          };
        }]

      });

  }]);
