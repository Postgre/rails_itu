'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.jobs.add', {

      url: '/add',
      templateUrl: appSettings.appPaths.features + '/company/jobs/templates/add.html',

      breadcrumb: {
        label: 'Adding new job position'
      },

      resolve: {
        job: ['modelize', 'companyId', function (modelize, companyId) {
          return modelize.one('company', companyId).many('jobs').$new();
        }]
      },

      controller: ['$scope', '$state', '$stateParams', 'jobs', 'job', 'modelize', 'humanizedMsg',
        function ($scope, $state, $stateParams, jobs, job, modelize, humanizedMsg) {
          $scope.model = job;

          $scope.create = function (model, publish) {
            var params = {};
            if (publish) params.publish = true;

            return model.save({ params: params }).then(function (newJob) {
              jobs.add(newJob);

              humanizedMsg.displayMsg('Job successfully created');

              $state.go('company.jobs.details.overview', { jobId: newJob.id });
            }, function(error) {
              $scope.errors = error.data;
            });
          };

        }]

    });

  }]);
