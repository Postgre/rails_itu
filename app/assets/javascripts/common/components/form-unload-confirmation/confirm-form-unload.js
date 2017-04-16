'use strict';

angular.module('bridge')

  .directive('confirmFormUnload', ['formUnloadConfirmationDialog', '$rootScope', '$state', '$window', 'stateChangeResolver', '$q', '$timeout',
    function (formUnloadConfirmationDialog, $rootScope, $state, $window, stateChangeResolver, $q, $timeout) {

      return {
        restrict: 'EA',
        require: 'form',
        scope: {
          confirmFormUnload: '='
        },

        link: function (scope, el, attrs, formCtrl) {
          var confirmationMessage = 'You have some unsaved form data. ' +
                                    'If you navigate away or close the window, ' +
                                    'form changes will be lost. ' +
                                    'Are you sure to proceed?';

          if (scope.confirmFormUnload === undefined) scope.confirmFormUnload = true;

          var shouldConfirm = function () {
            return formCtrl.$dirty && !!scope.confirmFormUnload;
          };

          var unlistenStateChange,
              isActive = false;

          var activate = function () {
            // Watch for either state/location change or 'beforeunload' event
            $window.onbeforeunload = function (e) {
              if (shouldConfirm()) return confirmationMessage;
            };

            unlistenStateChange = stateChangeResolver.addHandler(
              function (e, toState, toStateParams, fromState, fromStateParams) {
                if (!shouldConfirm()) return;

                e.preventDefault();

                var stateChangeDeferred = $q.defer();

                // Do nothing on "reject", and create a new state transition on "resolve"
                formUnloadConfirmationDialog.show({ message: confirmationMessage })
                  .then(stateChangeDeferred.resolve, stateChangeDeferred.reject);

                return stateChangeDeferred.promise;
              });

            isActive = true;
          };

          var deactivate = function () {
            $window.onbeforeunload = null;
            if (_.isFunction(unlistenStateChange)) unlistenStateChange();
            isActive = false;
          };

          // Do the actual work

          if (scope.confirmFormUnload) {
            activate();
          }

          scope.$watch('confirmFormUnload', function (needsConfirmation) {
            if (needsConfirmation) {
              if (!isActive) activate();
            } else if (isActive) {
              deactivate();
            }
          });

          formCtrl.disableUnloadConfirmation = function () {
            deactivate();
          };

          scope.$on('$destroy', function () {
            formCtrl.disableUnloadConfirmation = undefined;
            deactivate();
          });

        }
      };

    }]);
