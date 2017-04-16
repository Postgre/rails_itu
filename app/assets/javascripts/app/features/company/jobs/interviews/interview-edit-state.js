'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.job-interview-edit', {

        parent: 'company.jobs',
        url: '/:jobId/interviews/:interviewId/edit',
        templateUrl: appSettings.appPaths.features + '/company/jobs/interviews/templates/edit.html',
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

          interviewId: ['$stateParams', function ($stateParams) {
            return parseInt($stateParams.interviewId);
          }],

          interview: ['modelize', 'companyId', 'jobId', 'interviewId', function (modelize, companyId, jobId, interviewId) {
            return modelize.one('company', companyId).one('job', jobId).many('interviews').get(interviewId).$future;
          }]
        },

        controller: ['$scope', '$state', 'company', 'job', 'interview', 'humanizedMsg',
          function ($scope, $state, company, job, interview, humanizedMsg) {
            $scope.company = company;
            $scope.job = job;
            $scope.model = interview;

            $scope.update = function (model) {
              var wasTimeRejected = model.isTimeRejected(),
                  dateAttrChanged = model.hasDateAttrChanged();

              return model.save().then(function () {
                // In case time was rejected and is changed - send another request for state change
                if (wasTimeRejected && dateAttrChanged) {
                  model.changeTime().then(function () {
                    humanizedMsg.displayMsg('Interview time successfully updated');
                    $state.go('company.jobs.details.interviews', { jobId: job.id });
                  });

                } else {
                  humanizedMsg.displayMsg('Interview successfully updated');
                  $state.go('company.jobs.details.interviews', { jobId: job.id });
                }
              });
            };
          }]

      });

  }]);
