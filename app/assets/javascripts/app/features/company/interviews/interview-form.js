'use strict';

angular.module('bridge')

  .directive('interviewForm', ['$q', '$sce', 'promiseTracker', 'appSettings', 'modelize',
    function ($q, $sce, promiseTracker, appSettings, modelize) {

      return {

        restrict: 'EA',
        templateUrl: appSettings.appPaths.features + '/company/interviews/templates/_form.html',
        scope: {
          model: '=',
          isEdit: '=',
          onSubmit: '&'
        },

        link: function (scope, el, attrs) {
          var loadingTracker = promiseTracker();

          scope.submit = function () {
            var promise = $q.when(scope.onSubmit({ model: scope.model }));
            loadingTracker.addPromise(promise);

            return promise;
          };

          scope.isFormLoading = function () {
            return loadingTracker.active();
          };
        }

      };

    }]);
