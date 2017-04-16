'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.job-interview-invite', {

        parent: 'company.jobs',
        url: '/:jobId/interviews/invite/:candidateId',
        templateUrl: appSettings.appPaths.features + '/company/jobs/interviews/templates/invite.html',
        breadcrumb: {
          label: 'Editing interview'
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

          candidateId: ['$stateParams', function ($stateParams) {
            return parseInt($stateParams.candidateId);
          }],

          candidate: ['modelize', 'candidateId', function (modelize, candidateId) {
            return modelize.one('candidate', candidateId).get().$future;
          }],

          interview: ['modelize', 'companyId', 'jobId', function (modelize, companyId, jobId) {
            return modelize.one('company', companyId).one('job', jobId).many('interviews').$new();
          }]
        },

        controller: ['$scope', '$state', 'company', 'job', 'candidate', 'interview', 'humanizedMsg',
          function ($scope, $state, company, job, candidate, interview, humanizedMsg) {
            $scope.model = interview;

            interview.set({
              company: company,
              job: job,
              candidate: candidate
            });

            $scope.create = function (model) {
              return model.save().then(function () {
                candidate.isInvited = true;
                humanizedMsg.displayMsg('Interview successfully created');

                $state.go('company.jobs.details.interviews', { jobId: job.id });
              });
            };
          }]

      });

  }]);
