'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    // TODO: Think about moving to generic 'candidate-list-state' module
    // to be reusable (all candidate lists will have similar logic)

    $stateProvider.state('company.candidates.list.starred', {
      url: '/starred',
      templateUrl: appSettings.appPaths.features + '/company/candidates/templates/list-starred.html',

      resolve: {
        listFilter: function () {
          var filter = {
            page: null,
            availability: null,
            yearsOfExperience: null,
            degree: null,
            skillName: null
          };

          return filter;
        }
      },

      controllerAs: 'listCtrl',

      controller: ['$scope', '$state', 'modelize', 'listFilter', 'humanizedMsg', '$q', '$timeout', 'promiseTracker',
        function ($scope, $state, modelize, listFilter, humanizedMsg, $q, $timeout, promiseTracker) {

          var _this = this,
              loadingTracker = promiseTracker(),
              Candidate = modelize('candidates').$modelClass,
              candidates;

          $scope.listFilter = listFilter;
          candidates = $scope.candidates = Candidate.$newCollection();


          // Watch for filter changes
          $scope.$watchCollection('listFilter', function (newFilter, oldFilter) {
            if (!angular.equals(newFilter, oldFilter)) {
              if (newFilter.page === 1) newFilter.page = null;

              // candidates.fetch({ params: newFilter });
            }
          });

          $scope.isListLoading = function () {
            return candidates && candidates.$loading || loadingTracker.active();
          };



          // Pagination

          $scope.pagination = {
            currentPage: null,
            totalItems: 0,
            itemsPerPage: 10
          };

          $scope.showPagination = function () {
            return $scope.candidates.any() && $scope.pagination.totalItems > $scope.pagination.itemsPerPage;
          };

          $scope.$watchCollection('pagination', function (newPagination, oldPagination) {
            if (newPagination.currentPage === 1) newPagination.currentPage = null;
            if (newPagination.currentPage !== oldPagination.currentPage) {
              $scope.fetchCandidates({ page: newPagination.currentPage });
            }
          });
        }]
      });

  }]);
