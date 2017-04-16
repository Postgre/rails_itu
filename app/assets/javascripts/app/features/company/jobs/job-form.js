'use strict';

angular.module('bridge')

  .directive('jobForm', ['$q', '$sce', '$state', 'promiseTracker', 'appSettings', 'modelize', 'workTypes', 'jobSchedules', 'LoggedRestangular', '$timeout',
    function ($q, $sce, $state, promiseTracker, appSettings, modelize, workTypes, jobSchedules, LoggedRestangular, $timeout) {

      return {

        restrict: 'EA',
        templateUrl: appSettings.appPaths.features + '/company/jobs/templates/_form.html',
        scope: {
          model: '=',
          isEdit: '=',
          onSubmit: '&'
        },

        link: function (scope, el, attrs) {
          var loadingTracker = promiseTracker();
          scope.workTypes = workTypes;
          scope.jobSchedules = jobSchedules;

          scope.getAddresses = function (searchString) {
            if (!searchString) return [];

            return LoggedRestangular.all('geocoder').getList({ q: searchString }).then(function (res) {
              return LoggedRestangular.stripRestangular(res);
            });
          };

          scope.submit = function (publish) {
            scope._form.disableUnloadConfirmation();

            var promise = $q.when(scope.onSubmit({ model: scope.model, publish: publish }));
            loadingTracker.addPromise(promise);

            return promise;
          };

          scope.cancelForm = function () {
            scope._form.disableUnloadConfirmation();
            $state.go('company.jobs.list');
          };

          scope.publish = function () {
            return scope.submit(true);
          };

          scope.isFormLoading = function () {
            return loadingTracker.active();
          };
        }

      };

    }]);
