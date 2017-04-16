'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.job-interview-details', {

        parent: 'company.jobs',
        url: '/:jobId/interviews/:interviewId',
        templateUrl: appSettings.appPaths.features + '/company/jobs/interviews/templates/details.html',
        breadcrumb: {
          label: 'Interview details'
        },

        resolve: {
          company: ['modelize', 'companyId', function (modelize, companyId) {
            return modelize.one('company', companyId).get().$future;
          }],

          jobId: ['$stateParams', function ($stateParams) {
            return parseInt($stateParams.jobId);
          }],

          job: ['modelize', 'companyId', 'jobId', function (modelize, companyId, jobId) {
            return modelize.one('company', companyId).one('job', jobId).get().$future;
          }],

          interviewId: ['$stateParams', function ($stateParams) {
            return parseInt($stateParams.interviewId);
          }],

          interview: ['modelize', 'companyId', 'jobId', 'interviewId', function (modelize, companyId, jobId, interviewId) {
            return modelize.one('company', companyId).one('job', jobId).many('interviews').get(interviewId).$future;
          }]
        },

        controller: ['$scope', 'company', 'job', 'interview', function ($scope, company, job, interview) {
          $scope.company = company;
          $scope.job = job;
          $scope.interview = interview;

          $scope.cancel = function () {
            $scope.interview.cancel().then(function () {
              humanizedMsg.displayMsg('Interview has been cancelled');
            });
          };

          $scope.setHired = function () {
            scope.interview.setHired().then(function () {
              humanizedMsg.displayMsg('You\'ve hired the candidate');
            });
          };
        }]

      })

      .state('company.job-interview-details.comments', {
        url: '/comments'
      });

  }]);
