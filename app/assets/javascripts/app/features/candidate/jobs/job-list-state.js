'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    // Notes:
    //
    // - Abstract state to be reused across all candidate job lists
    //   Note: This contains the list and maintains its state while
    //   children states might be reloaded with updated querystring
    //   parameters safely without causing the main list to reload.
    //
    // - List sub-states only handle URL param changes and update
    //   shared filter objects that abstract state holds watches
    //   for, as well as responsible for re-rendering the "filter"
    //   views so that all links, etc are updated accordingly.

    var defaultSortOrder = 'unmatched_skill_count';

    var defaultFilterParams = {
      isFavorited: null,
      hasApplied: null
    };

    $stateProvider.state('candidate.jobs.list-abstract', {
      abstract: true,
      url: '',
      templateUrl: appSettings.appPaths.features + '/candidate/jobs/templates/list.html',

      resolve: {
        listFilter: function () {
          var filter = {
            topFilter: null, // Defines the "part", i.e., "All", "Starred", "Recommended", etc
            s: null,
            schedule: null,
            status: null,
            order: null,
            page: null // Might be not necessary here
          };

          return filter;
        },

        filterFacets: function () {
          return {
             // Wrapper to let states hold the reference to the 'filterFacets' object itself
            data: {
              companyNames: {},
              skillNames: {}
            }
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

      controller: ['$scope', '$state', 'modelize', 'listFilter', 'filterFacets', 'pagination',
        function ($scope, $state, modelize, listFilter, filterFacets, pagination) {
          $scope.listFilter   = listFilter;
          $scope.filterFacets = filterFacets;
          $scope.pagination   = pagination;

          $scope.jobs = modelize('candidateJobs').$newCollection();
          $scope.recommendedJobs = modelize('candidateJobs').$newCollection();


          var prepareFetchParams = function (filterParams) {
            // Prepare params
            var fetchParams = filterParams ? _.clone(filterParams) : {};

            // Account for default sort order
            if (!fetchParams.order) fetchParams.order = defaultSortOrder;

            // Converting search params for ransack
            fetchParams.q = {
              skillsNameOrCompanyNameCont: fetchParams.s || null,
              skillsNameCont:  fetchParams.skillName || null,
              companyNameCont: fetchParams.companyName || null,
              scheduleEq:      fetchParams.schedule || null,
              stateEq:         'published'
            };

            // Only include non-null params
            fetchParams.q = _.pick(fetchParams.q, function (attr) {
              return !!attr;
            });

            if (_.isEmpty(fetchParams.q)) delete fetchParams.q;

            // Cleanup all client-specific stuff
            fetchParams = _.omit(fetchParams, 'topFilter', 's', 'skillName', 'companyName', 'status', 'schedule');

            return fetchParams;
          };

          var fetchJobs = function (filterParams) {
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

          var fetchRecommendedJobs = function (filterParams) {
            // Override with default filter params to prevent fetching has_applied or is_favorited
            // only when you need recommended
            var fetchParams = _.extend({}, prepareFetchParams(filterParams), defaultFilterParams);

            $scope.recommendedJobs.fetchRecommended({ params: fetchParams });
          };

          // Note: recommendations are fetched always (hopefully - temp)
          // to get the items count right away (should be done in some
          // different way).
          fetchRecommendedJobs(listFilter);

          // Ugly temp check, will be refactored to a specialized sub-state
          if (!$state.is('candidate.jobs.list.recommended')) {
            fetchJobs(listFilter);
          }

          // Watch for filter changes
          $scope.$watchCollection('listFilter', function (newFilter, oldFilter) {
            if (!angular.equals(newFilter, oldFilter)) {

              // Page change
              // Note: It would be much better if pagination was
              // controlled with a links to current state, preserving
              // other params and changing "page" param.
              // Then this ugly piece of code could be just easily extracted
              // if (newFilter.page !== oldFilter.page) {
              //   if (newFilter.page === 1) newFilter.page = null;
              //   $state.go('.', { page: newFilter.page });
              // }


              if (newFilter.s !== $scope.search.s) {
                $scope.search.s = newFilter.s;
              }


              if (newFilter.order !== oldFilter.order) {
                // if (newFilter.order === defaultSortOrder) newFilter.order = null;

                $state.go('.', { order: newFilter.order, page: null });
              }

              // TEMP
              if (newFilter.topFilter === 'recommended') {
                return fetchRecommendedJobs(newFilter);
              }

              fetchJobs(newFilter);
            }
          });

          $scope.showFilterOptions = function () {
            if (!listFilter) return false;

            return _.any(['topFilter', 's', 'schedule', 'status', 'skillName', 'companyName'], function (prop) {
              return !!listFilter[prop];
            }) || listFilter.order !== defaultSortOrder;
          };


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


          // Search feature

          $scope.search = {
            s: listFilter.s,
          };

          var searchAttempted = !!$scope.search.s;

          $scope.suggestionsLoading = false;

          $scope.updateSearchQuery = function (query) {
            query = query || $scope.search.s;
            $state.go('.', { s: query, skillName: null, page: null });
          };

          // User attempted but nothing is found
          $scope.nothingIsFound = function () {
            return searchAttempted && $scope.search.s && !$scope.jobs.any();
          };

          $scope.clearSearch = function () {
            $scope.search.s = null;

            $state.go('.', {
              s: null,
              skillName: null,
              page: null
            });

            searchAttempted = false;
          };

          $scope.suggestSearch = function () {
            // No suggestions currently (WIP)
            return false;
          };


          // Other view helpers

          $scope.isListLoading = function () {
            return $scope.jobs.$loading;
          };

          $scope.isRecommendationListLoading = function () {
            return $scope.recommendedJobs.$loading;
          };

          $scope.orderField = function (job) {
            if (!$scope.listFilter.order || $scope.listFilter.order === 'unmatched_skill_count') {
              return job.unmatchedSkillCount;
            }

            return job.lastStateChangeAt;
          };

        }]
    });


    var queryParams = '?s&status&schedule&skillName&companyName&order&page';

    var filterSubStates = [
      { name: '',            url: '',             filterParams: { topFilter: null } }, // Default
      { name: 'recommended', url: '/recommended', filterParams: { topFilter: 'recommended' } },
      { name: 'applied',     url: '/applied',     filterParams: { topFilter: 'applied', hasApplied: true } },
      { name: 'starred',     url: '/starred',     filterParams: { topFilter: 'starred', isFavorited: true } }
    ];

    var subStateNamePrefix = 'candidate.jobs.list';

    filterSubStates.forEach(function (subState) {
      var stateName = subState.name ? [subStateNamePrefix, subState.name].join('.') : subStateNamePrefix;

      $stateProvider.state(stateName, {
        parent: 'candidate.jobs.list-abstract',
        url: subState.url + queryParams,
        views: {
          'nav-tabs': {
            templateUrl: appSettings.appPaths.features + '/candidate/jobs/templates/_job-list-nav-tabs.html'
          },
          'side-filter': {
            templateUrl: appSettings.appPaths.features + '/candidate/jobs/templates/_job-list-side-filter.html'
          }
        },

        onEnter: ['$stateParams', 'listFilter', 'pagination', function ($stateParams, listFilter, pagination) {
          _.extend(pagination, { currentPage: $stateParams.page });
          _.extend(listFilter, $stateParams, defaultFilterParams, subState.filterParams, { page: pagination.currentPage });
          if (!listFilter.order) listFilter.order = defaultSortOrder;
        }]
      });
    });

  }]);
