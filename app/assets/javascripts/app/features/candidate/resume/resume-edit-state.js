'use strict';

angular.module('bridge.app')

  .config(['$stateProvider', 'appSettings', 'countries', function ($stateProvider, appSettings, countries) {

    $stateProvider.state('candidate.resume.edit', {

      url: '/resume/edit',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/templates/edit.html',

      breadcrumb: {
        label: 'Edit profile information'
      },

      controllerAs: 'formCtrl',

      controller: ['$scope', '$state', 'modelize', 'availabilityOptions', 'humanizedMsg', 'promiseTracker',
        function ($scope, $state, modelize, availabilityOptions, humanizedMsg, promiseTracker) {
          var _this = this,
              loadingTracker = promiseTracker(),
              promise;

          $scope.model = modelize.one('candidateProfile').get().$future;

          $scope.showIsVisibleLocked = function () {
            if ($scope.model.isVisibleLocked) return 'hover';
            return 'manual';
          };

          // Load reference lists data
          $scope.availabilityOptions = availabilityOptions;

          $scope.countries = countries;

          // Regions
          $scope.regions = [];

          // Initial regions fetch
          if ($scope.model.countryIso3) {
            var promise = modelize('/countries/' + $scope.model.countryIso3 + '/regions').all();
            loadingTracker.addPromise(promise);

            promise.then(function (regions) {
              $scope.regions = regions;
            });
          }

          $scope.$watch('model.countryIso3', function (countryIso3, oldCountryIso3) {
            if (countryIso3 === oldCountryIso3) return;

            $scope.regions = [];
            if (!countryIso3) $scope.model.region = null;

            if (countryIso3) {
              var regionsPromise = modelize('/countries/' + countryIso3 + '/regions').all();
              loadingTracker.addPromise(regionsPromise);

              regionsPromise.then(function (regions) {
                $scope.regions = regions;
              });
            }
          });


          $scope.updateProfile = function () {
            return $scope.model.save().then(function () {
              humanizedMsg.displayMsg('Profile successfully updated');

              $scope._form.disableUnloadConfirmation();
              $state.go('candidate.resume.index');
            });
          };

          $scope.cancelForm = function () {
            $scope._form.disableUnloadConfirmation();
            $state.go('candidate.resume.index');
          };

          $scope.isFormLoading = function () {
            return $scope.model.$loading;
          };

          $scope.areReferenceLoading = function () {
            return loadingTracker.active();
          };

        }]

    });

  }]);
