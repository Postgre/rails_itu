'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.jobs.list-abstract', {
        abstract: true,
        url: '',
        templateUrl: appSettings.appPaths.features + '/company/jobs/templates/list.html',

        resolve: {
          listFilter: function () {
            return {
              state: null,
              withInterviews: null
            };
          },

          pagination: function () {
            return {
              currentPage: null,
              totalItems: 0,
              itemsPerPage: 10
            };
          }
        },

        controller: ['$scope', 'companyId', 'jobs', 'listFilter', 'modelize', 'humanizedMsg', 'pagination',
          function ($scope, companyId, jobs, listFilter, modelize, humanizedMsg, pagination) {
            $scope.jobs = jobs;
            $scope.listFilter = listFilter;

            $scope.anyJobsInState = function (state) {
              return state && _.any($scope.jobs, { state: state });
            };

            var prepareFetchParams = function (filterParams) {
              // Prepare params
              var fetchParams = filterParams ? _.clone(filterParams) : {};

              if (fetchParams.withInterviews !== true) delete fetchParams.withInterviews;

              return fetchParams;
            };

            var fetchList = function (filterParams) {
              // Note: We could request lists from different endpoints by providing
              // `url` option to .fetch(...). URL, in turn, can be constructed based
              // on listFilter.topFilter parameter.

              // Fetch
              $scope.jobs.fetch(_.extend({ params: prepareFetchParams(filterParams) }, {
                onSuccess: function (res) {
                  pagination.totalItems   = parseInt(res.headers('X-total'));
                  pagination.itemsPerPage = parseInt(res.headers('X-limit'));
                }
              }));
            };

            // fetchList(listFilter);


            // Watch for filter changes
            $scope.$watchCollection('listFilter', function (newFilter, oldFilter) {
              if (angular.equals(newFilter, oldFilter)) return;

              // if (newFilter.state === oldFilter.state) return;
              if (newFilter.withInterviews !== newFilter.withInterviews) {
                $state.go('.', { withInterviews: newFilter.withInterviews, page: null });
              }

              fetchList(newFilter);
            });



            // Pagination

            $scope.showPagination = function () {
              return pagination.totalItems && parseInt(pagination.totalItems) > parseInt(pagination.itemsPerPage);
            };

            $scope.$watch('pagination.currentPage', function (newPage, oldPage) {
              if (newPage === 1) newPage = null;
              if (newPage !== oldPage) {
                // Update the querystring - it will cause jobs re-fetch, etc
                $state.go('.', { page: newPage });
              }
            });
          }]
      })

      // Note: this state is to represent a filterable
      // sub-state, prevents abstract state from reloading
      // on querystring param change.
      .state('company.jobs.list', {
        url: '?state&page',
        parent: 'company.jobs.list-abstract',
        views: {
          'side-filter': {
            templateUrl: appSettings.appPaths.features + '/company/jobs/templates/_job-list-side-filter.html'
          }
        },

        onEnter: ['jobs', 'listFilter', '$stateParams', 'pagination', function (jobs, listFilter, $stateParams, pagination) {
          _.extend(pagination, { currentPage: $stateParams.page });
          listFilter.state = $stateParams.state;
        }]
      });

  }]);
