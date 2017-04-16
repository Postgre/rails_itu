'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.jobs.edit', {

      url: '/:jobId/edit',
      templateUrl: appSettings.appPaths.features + '/company/jobs/templates/edit.html',

      breadcrumb: {
        label: 'Editing'
      },

      resolve: {
        jobId: ['$stateParams', function ($stateParams) {
          return parseInt($stateParams.jobId);
        }],

        job: ['modelize', 'companyId', 'jobId', 'jobs', function (modelize, companyId, jobId, jobs) {
          return jobs.get(jobId) || modelize.one('company', companyId).one('job', jobId).get().$future;
        }]
      },

      controller: ['$scope', '$state', '$stateParams', 'job', 'modelize', 'humanizedMsg', '$q',
        function ($scope, $state, $stateParams, job, modelize, humanizedMsg, $q) {
          $scope.model = job;

          $scope.update = function (model) {
            if (model.isClosed()) return $q.reject();

            return model.save().then(function () {
              humanizedMsg.displayMsg('Job successfully updated');

              $state.go('company.jobs.list');
            }, function(error) {
              $scope.errors = error.data;
            });
          };

        }]

    });

  }]);
