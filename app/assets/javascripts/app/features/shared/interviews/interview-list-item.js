'use strict';

angular.module('bridge')

  .directive('interviewListItem', ['appSettings', 'humanizedMsg', 'interviewRejectTimeModal',
    function (appSettings, humanizedMsg, interviewRejectTimeModal) {

      return {

        restrict: 'EA',
        templateUrl: appSettings.appPaths.features + '/shared/interviews/templates/_interview-list-item.html',
        scope: {
          interview: '=',
          job: '=',
          company: '=',
          aspect: '@'
        },

        link: function (scope, el, attrs) {
          scope.isCandidateViewing = function () {
            return scope.aspect === 'candidate';
          };

          scope.isCompanyViewing = function () {
            return scope.aspect === 'company';
          };

          scope.showAnyActions = function () {
            return scope.interview && scope.interview.job && !scope.interview.job.isClosed();
          };

          scope.showCandidateActions = function () {
            return scope.showAnyActions() && scope.isCandidateViewing() && scope.interview &&
                  (scope.interview.canBeAccepted() || scope.interview.canBeRejected() || scope.interview.canBeTimeRejected());
          };

          scope.showCompanyActions = function () {
            return scope.showAnyActions() && scope.isCompanyViewing() && scope.interview &&
                  (scope.interview.canBeCancelled() || scope.interview.canBeSetHired() || scope.interview.isTimeRejected());
          };

          scope.isJobContext = function () {
            return !!scope.job;
          };

          // Workflow methods

          scope.accept = function () {
            scope.interview.accept().then(function () {
              humanizedMsg.displayMsg('Interview has been accepted');
            });
          };

          scope.reject = function () {
            scope.interview.reject().then(function () {
              humanizedMsg.displayMsg('Interview has been rejected');
            });
          };

          scope.rejectTime = function () {
            interviewRejectTimeModal.open({ interview: scope.interview }).result.then(function (interview) {
              humanizedMsg.displayMsg('New interview time has been suggested');
            });
          };

          scope.cancel = function () {
            scope.interview.cancel().then(function () {
              humanizedMsg.displayMsg('Interview has been cancelled');
            });
          };

          scope.setHired = function () {
            scope.interview.setHired().then(function () {
              humanizedMsg.displayMsg('You\'ve hired the candidate');
            });
          };
        }

      };

    }]);
