'use strict';

angular.module('bridge')

  .directive('employmentRecordForm', ['$q', '$sce', '$state', 'promiseTracker', 'lookupData', '$timeout', 'appSettings', 'countries', 'modelize',
    function ($q, $sce, $state, promiseTracker, lookupData, $timeout, appSettings, countries, modelize) {

      return {

        restrict: 'EA',
        templateUrl: appSettings.appPaths.features + '/candidate/resume/employment/templates/_form.html',
        scope: {
          model: '=',
          isEdit: '&',
          onSubmit: '&',
          errors: '='
        },
        link: function (scope, el, attrs) {
          var loadingTracker    = promiseTracker(),
              refLoadingTracker = promiseTracker();

          scope.countries = countries;

          // Regions
          scope.regions = [];

          // Initial regions fetch
          if (scope.model.countryIso3) {
            var regionsPromise = modelize('/countries/' + scope.model.countryIso3 + '/regions').all();
            refLoadingTracker.addPromise(regionsPromise);

            regionsPromise.then(function (regions) {
              _this.regions = regions;
            });
          }

          scope.$watch('model.countryIso3', function (countryIso3, oldCountryIso3) {
            if (countryIso3 === oldCountryIso3) return;

            scope.regions = [];
            if (!countryIso3) scope.model.region = null;

            if (countryIso3) {
              var regionsPromise = modelize('/countries/' + countryIso3 + '/regions').all();
              refLoadingTracker.addPromise(regionsPromise);

              regionsPromise.then(function (regions) {
                scope.regions = regions;
              });
            }
          });


          scope.submit = function () {
            if (scope.isFormLoading()) return;
            scope._form.disableUnloadConfirmation();

            var promise = $q.when(scope.onSubmit({ model: scope.model }));
            loadingTracker.addPromise(promise);

            return promise;
          };

          scope.cancelForm = function () {
            scope._form.disableUnloadConfirmation();
            $state.go('candidate.resume.employment.list');
          };

          scope.isFormLoading = function () {
            return loadingTracker.active();
          };

          scope.areReferencesLoading = function () {
            return refLoadingTracker.active();
          };
        }

      };

    }]);
