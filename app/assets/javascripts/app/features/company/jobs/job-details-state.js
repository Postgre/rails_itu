'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.jobs.details', {

        abstract: true,
        url: '/:jobId',
        templateUrl: appSettings.appPaths.features + '/company/jobs/templates/details-layout.html',
        breadcrumb: {
          label: 'Job details',
          stateRef: 'company.jobs.details.overview'
        },

        resolve: {
          jobId: ['$stateParams', function ($stateParams) {
            return parseInt($stateParams.jobId);
          }],

          job: ['modelize', 'companyId', 'jobId', 'jobs', function (modelize, companyId, jobId, jobs) {
            return jobs.get(jobId) || modelize.one('company', companyId).one('job', jobId).get().$future;
          }]
        },

        controller: ['$scope', '$stateParams', 'company', 'job', 'humanizedMsg', function ($scope, $stateParams, company, job, humanizedMsg) {
          $scope.company = company;
          $scope.job = job;

          $scope.makeDraft = function () {
            $scope.job.makeDraft().then(function () {
              humanizedMsg.displayMsg('Successfully saved as draft');
            });
          };

          $scope.publish = function () {
            $scope.job.publish().then(function () {
              humanizedMsg.displayMsg('Published successfully');
            });
          };

          $scope.setFilled = function () {
            $scope.job.setFilled().then(function () {
              humanizedMsg.displayMsg('Marked as filled successfully');
            });
          };

          $scope.close = function () {
            $scope.job.close().then(function () {
              humanizedMsg.displayMsg('Position closed successfully');
            });
          };
        }]

      })

      // States below are represented as tabs on UI

      .state('company.jobs.details.overview', {

        url: '',
        templateUrl: appSettings.appPaths.features + '/company/jobs/templates/details-overview.html'

      })

      .state('company.jobs.details.recommendations', {

        url: '/recommendations',
        templateUrl: appSettings.appPaths.features + '/company/jobs/templates/details-recommendations.html',

        controller: ['$scope', '$stateParams', 'job', 'modelize', function ($scope, $stateParams, job, modelize) {
          $scope.job = job;
          $scope.recommendations = modelize('candidates').all({ urlPrefix: job.resourceUrl(), baseUrl: '/recommended' }).$future;
        }]

      })

      .state('company.jobs.details.applies', {

        url: '/applications',
        templateUrl: appSettings.appPaths.features + '/company/jobs/templates/details-applications.html',

        controller: ['$scope', '$stateParams', 'job', 'modelize', function ($scope, $stateParams, job, modelize) {
          $scope.job = job;
          $scope.applications = modelize('jobApplications').all({ urlPrefix: job.resourceUrl() }).$future;
        }]

      })

      .state('company.jobs.details.interviews', {

        url: '/interviews',
        templateUrl: appSettings.appPaths.features + '/company/jobs/templates/details-interviews.html',

        resolve: {
          interviews: ['job', 'companyId', 'modelize', function (job, companyId, modelize) {
            return modelize.one('company', companyId).one('job', job.id).many('interviews').all().$future;
          }]
        },

        controller: ['$scope', '$stateParams', 'job', 'interviews', function ($scope, $stateParams, job, interviews) {
          $scope.interviews = interviews;
        }]

      });

  }]);
