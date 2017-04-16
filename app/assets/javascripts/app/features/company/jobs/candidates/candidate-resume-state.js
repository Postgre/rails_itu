'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.job-candidate-resume', {

      // parent: 'company.jobs', // TODO: Doesn't work for some reason (causes ui-router error)
      url: '/jobs/:jobId/recommendations/:candidateId/resume',
      templateUrl: appSettings.appPaths.features + '/company/jobs/candidates/templates/resume.html',
      breadcrumb: {
        label: 'Candidate resume'
      },

      resolve: {
        candidate: ['modelize', '$stateParams', 'jobId', function (modelize, $stateParams, jobId) {
          return modelize.one('candidate', $stateParams.candidateId).get({ params: { jobId: jobId } });
        }],

        jobId: ['$stateParams', function ($stateParams) {
          return parseInt($stateParams.jobId);
        }],

        job: ['modelize', 'companyId', 'jobId', function (modelize, companyId, jobId) {
          return modelize.one('company', companyId).one('job', jobId).get().$future;
        }]
      },

      controllerAs: 'resumeCtrl',

      controller: ['$scope', '$stateParams', 'company', 'candidate', 'job', function ($scope, $stateParams, company, candidate, job) {
        $scope.candidate = candidate;
        $scope.company = company;
        $scope.job = job;
      }]

    });

  }]);
