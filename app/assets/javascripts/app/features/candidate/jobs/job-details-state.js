'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.jobs.details', {

      url: '/{jobId:[0-9]+}',
      templateUrl: appSettings.appPaths.features + '/candidate/jobs/templates/details.html',

      breadcrumb: {
        label: 'Job details'
      },

      resolve: {
        job: ['$stateParams', 'modelize', function ($stateParams, modelize) {
          return modelize.one('candidate/jobs', parseInt($stateParams.jobId)).get().$future;
        }]
      },

      controller: ['$scope', '$stateParams', 'job', function ($scope, $stateParams, job) {
        $scope.job = job;

        $scope.canApply = function () {
          return !$scope.job.isApplied;
        };

        $scope.showCandidateOptions = function () {
          return $scope.canApply();
        };

      }]

    });

  }]);
