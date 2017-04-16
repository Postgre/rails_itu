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

    var defaultSortOrder = 'newest_first';

    var defaultFilterParams = {
      isFollowed: null,
      withJobs: null
    };

    $stateProvider.state('candidate.companies.list-abstract', {
      abstract: true,
      url: '',
      templateUrl: appSettings.appPaths.features + '/candidate/companies/templates/list.html',

      resolve: {
        listFilter: function () {
          var filter = {
            s: null, // Search query
            isFollowed: null,
            withJobs: null,
            order: null,
            page: null // Might be not necessary here
          };

          return filter;
        },

        pagination: function () {
          return {
            currentPage: null,
            totalItems: 0,
            itemsPerPage: 10
          };
        }
      },

      controller: ['$scope', '$state', 'modelize', 'listFilter', 'pagination',
        function ($scope, $state, modelize, listFilter, pagination) {
          $scope.listFilter   = listFilter;
          $scope.pagination   = pagination;

          $scope.companies = modelize('companies').$newCollection();


          var prepareFetchParams = function (filterParams) {
            // Prepare params
            var fetchParams = filterParams ? _.clone(filterParams) : {};

            // Order setup
            if (fetchParams.order === 'oldest_first') {
              fetchParams.order = 'created_at';
            } else {
              // Including when its default
              fetchParams.order = 'created_at';
              fetchParams.reverse = true;
            }

            // Converting search params for ransack
            fetchParams.q = {
              nameCont: fetchParams.s || null,
            };

            if (fetchParams.withJobs) fetchParams.q.withJobs = true;
            if (fetchParams.isFollowed) fetchParams.q.followed = true;

            // // Only include non-null params
            fetchParams.q = _.pick(fetchParams.q, function (attr) {
              return !!attr !== null;
            });

            if (_.isEmpty(fetchParams.q)) delete fetchParams.q;

            // Cleanup all client-specific stuff
            // TODO: Handle 'isFollowed' correctly
            fetchParams = _.omit(fetchParams, 's', 'withJobs', 'isFollowed');

            return fetchParams;
          };

          var fetchList = function (filterParams) {
            // Note: We could request lists from different endpoints by providing
            // `url` option to .fetch(...). URL, in turn, can be constructed based
            // on listFilter.topFilter parameter.

            // Fetch
            $scope.companies.fetch(_.extend({ params: prepareFetchParams(filterParams) }, {
              onSuccess: function (res) {
                pagination.totalItems   = parseInt(res.headers('X-total'));
                pagination.itemsPerPage = parseInt(res.headers('X-limit'));
              }
            }));
          };

          fetchList(listFilter);

          // Watch for filter changes
          $scope.$watchCollection('listFilter', function (newFilter, oldFilter) {
            if (angular.equals(newFilter, oldFilter)) return;

            // Page change
            // Note: It would be much better if pagination was
            // controlled with a links to current state, preserving
            // other params and changing "page" param.
            // Then this ugly piece of code could be just easily extracted
            // if (newFilter.page !== oldFilter.page) {
            //   if (newFilter.page === 1) newFilter.page = null;
            //   $state.go('.', { page: newFilter.page });
            // }

            // To handle non-link filters and clean params override
            var newStateParams = {
              page: null
            };


            if (newFilter.s !== $scope.search.s) {
              $scope.search.s = newFilter.s;
              $state.go('.', { s: newFilter.s, page: null });
            }

            if (!newFilter.isFollowed) newStateParams.isFollowed = null;
            if (!newFilter.withJobs)   newStateParams.withJobs = null;

            if (newFilter.order !== oldFilter.order) {
              newStateParams.order = newFilter.order;
            }

            // $state.go('.', newStateParams);

            fetchList(newFilter);
          });

          $scope.showFilterOptions = function () {
            if (!listFilter) return false;

            return _.any(['s', 'isFollowed', 'withJobs'], function (prop) {
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
            $state.go('.', { s: query, page: null });
          };

          // User attempted but nothing is found
          $scope.nothingIsFound = function () {
            return searchAttempted && $scope.search.s && !_.any($scope.companies);
          };

          $scope.clearSearch = function () {
            $scope.search.s = null;

            $state.go('.', {
              s: null,
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
            return $scope.companies.$loading;
          };

          $scope.orderField = function (item) {
            if (!$scope.listFilter.order || $scope.listFilter.order === 'newest_first') {
              return item.createdAt;
            }

            return item.createdAt;
          };

        }]
    });


    var queryParams = '?s&isFollowed&withJobs&order&page';

    $stateProvider.state('candidate.companies.list', {
      url: queryParams,
      parent: 'candidate.companies.list-abstract',
      views: {
        'side-filter': {
          templateUrl: appSettings.appPaths.features + '/candidate/companies/templates/_company-list-side-filter.html'
        }
      },

      onEnter: ['$stateParams', 'listFilter', 'pagination', function ($stateParams, listFilter, pagination) {
        _.extend(pagination, { currentPage: $stateParams.page });
        _.extend(listFilter, $stateParams, { page: pagination.currentPage });
        if (!listFilter.order) listFilter.order = defaultSortOrder;
      }]
    });

  }]);
