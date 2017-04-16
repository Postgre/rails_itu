'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.candidates.list.search-abstract', {
        abstract: true,
        url: '',

        resolve: {
          Candidate: ['modelize', function (modelize) {
            return modelize('candidates').$modelClass;
          }],

          candidates: ['Candidate', function (Candidate) {
            return Candidate.$newCollection();
          }],

          loadingTracker: ['promiseTracker', function (promiseTracker) {
            return promiseTracker();
          }],

          listFilter: function () {
            return {
              page: null,
              query: null,
              availability: null,
              yearsOfExperience: null,
              degree: null,
              skillName: null
            };
          },

          filterFacets: function () {
            return {
               // Wrapper to let states hold the reference to the 'filterFacets' object itself
              data: {
                availability: {},
                skillNames: {},
                yearsOfExperience: {},
                degrees: {}
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

        reloadOnSearch: false,


        templateUrl: appSettings.appPaths.features + '/company/candidates/templates/list-search.html',

        controllerAs: 'listCtrl',

        controller: ['$scope', '$state', '$stateParams', 'modelize', 'Candidate', 'candidates', 'listFilter', 'filterFacets', 'pagination', 'loadingTracker', 'humanizedMsg', '$q', '$timeout', 'promiseTracker', '$location',
          function ($scope, $state, $stateParams, modelize, Candidate, candidates, listFilter, filterFacets, pagination, loadingTracker, humanizedMsg, $q, $timeout, promiseTracker, $location) {

            var _this = this;

            $scope.listFilter = listFilter;
            $scope.candidates = candidates;

            $scope.isListLoading = function () {
              return candidates && candidates.$loading || loadingTracker.active();
            };


            // Filters

            $scope.showFilters = function () {
              return candidates && candidates.any();
            };

            // TODO: Find a way to bypass using this ugly ".data"
            $scope.filterFacets = filterFacets;

            $scope.countByAvailability = function (availability) {
              if (!availability) return $scope.filterFacets.data.availability.total || 0;

              var terms = $scope.filterFacets.data.availability.terms;
              if (!terms) return 0;

              for (var i = 0; i < terms.length; i++) {
                if (terms[i].term === availability) return terms[i].count || 0;
              }

              return 0;
            };


            // Pagination

            $scope.pagination = pagination;

            $scope.showPagination = function () {
              return $scope.candidates.any() && $scope.pagination.totalItems > $scope.pagination.itemsPerPage;
            };

            $scope.$watchCollection('pagination', function (newPagination, oldPagination) {
              if (newPagination.currentPage === 1) newPagination.currentPage = null;
              if (newPagination.currentPage !== oldPagination.currentPage) {
                $state.go('company.candidates.list.search', { page: newPagination.currentPage });
              }
            });


            // Search feature


            $scope.search = {
              query: listFilter.query,
            };

            var searchAttempted = !!$scope.search.query;

            $scope.suggestionsLoading = false;

            $scope.updateSearchQuery = function (query) {
              query = query || $scope.search.query;
              $state.go('company.candidates.list.search', { query: query, skillName: null, page: null });
            };


            // User attempted but nothing is found
            $scope.nothingIsFound = function () {
              return searchAttempted && $scope.search.query && !candidates.any();
            };

            $scope.clearSearch = function () {
              $scope.search.query = null;

              // TODO: Refactor to prevent param duplication across the code
              $state.go('company.candidates.list.search', {
                query: null,
                skillName: null,
                page: null,
                availability: null,
                yearsOfExperience: null,
                degree: null
              });

              searchAttempted = false;
            };

            $scope.suggestSearch = function () {
              // No suggestions currently (WIP)
              return false;
            };

            $scope.onSuggestionSelected = function ($item, $model, $label) {
              
            };
          }]
      })

      .state('company.candidates.list.search', {
        parent: 'company.candidates.list.search-abstract',
        url: '?query&availability&skillName&yearsOfExperience&degree&page',

        onEnter: ['$stateParams', '$q', 'listFilter', 'Candidate', 'candidates', 'filterFacets', 'pagination', 'loadingTracker', 'availabilityOptions',
          function ($stateParams, $q, listFilter, Candidate, candidates, filterFacets, pagination, loadingTracker, availabilityOptions) {

            // Test facets
            var testFacets = {
              availability: {
                total: 3,
                terms: [{
                  term: 'not_available',
                  count: 1,
                }, {
                  term: 'available_full_time',
                  count: 1,
                }, {
                  term: 'available_part_time',
                  count: 3,
                }]
              },
              skillName: {
                total: 60,
                terms: [{
                  term: 'Ruby',
                  count: 12,
                }, {
                  term: 'Ruby on Rails',
                  count: 45,
                }, {
                  term: 'Rubinius',
                  count: 3,
                }]
              },
              yearsOfExperience: {
                total: 60,
                terms: [{
                  term: 'Less than 1 year',
                  count: 12,
                }, {
                  term: '1-2 years',
                  count: 10,
                }, {
                  term: '3-5 years',
                  count: 3,
                }, {
                  term: '6-8 years',
                  count: 7,
                }, {
                  term: '8-10 years',
                  count: 11,
                }, {
                  term: 'More than 10 years',
                  count: 22
                }]
              },
              degree: {
                total: 1,
                terms: [{
                  term: 'Master\'s degree of Business Management',
                  count: 1,
                }]
              }
            };

            var isFilterEmpty = function () {
              // Maybe find some lodash method for this?
              return !listFilter || !(listFilter.query || listFilter.availability ||
                                      listFilter.skillName || listFilter.yearsOfExperience || listFilter.degree);
            };

            var _updateFilterFacets = function (facets) {
              var facetsData = facets;

              // This code is to be gone when server returns 'available_full_time'-like availability options
              if (facetsData.availability && facetsData.availability.terms) {
                facetsData.availability.terms = _.compact(_.map(facetsData.availability.terms, function (term) {
                  var availabilityOption = _.find(availabilityOptions, { numericValue: term.term });
                  term.term = availabilityOption ? availabilityOption.value : null;

                  return term;
                }));
              }

              filterFacets.data = facetsData;
            };

            var fetchCandidates = function (params) {
              if (isFilterEmpty()) {
                candidates.reset();
                return $q.reject();
              }

              params = params ? _.clone(params) : {};
              if (params.availability) {
                var availabilityOption = _.find(availabilityOptions, { value: params.availability });
                params.availability = availabilityOption ? availabilityOption.numericValue : null;
              }

              var promise = Candidate.search(listFilter.query, { params: params }).then(function (searchResult) {
                candidates.reset(searchResult.candidates, { remove: true });
                pagination.totalItems = searchResult.meta && (searchResult.meta.totalCount || 0);
                pagination.itemsPerPage = searchResult.meta && (searchResult.meta.perPage || 10);

                // Test facets currently
                // _updateFilterFacets(testFacets);

                if (searchResult.meta && searchResult.meta.facets) {
                  _updateFilterFacets(searchResult.meta.facets);
                }
              });

              loadingTracker.addPromise(promise);

              return promise;
            };


            _.extend(listFilter, {
              page: null,
              query: null,
              availability: null,
              yearsOfExperience: null,
              degree: null,
              skillName: null
            }, $stateParams);

            pagination.currentPage = listFilter.page;
            
            fetchCandidates(listFilter);
          }]
      });

  }]);
