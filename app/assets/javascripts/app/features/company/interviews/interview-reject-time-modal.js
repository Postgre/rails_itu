'use strict';

angular.module('bridge')

  .factory('interviewRejectTimeModal', ['$q', 'modalbox', 'modelize', 'promiseTracker',
    function ($q, modalbox, modelize, promiseTracker) {

      var loadingTracker = promiseTracker();

      return {
        open: function (options) {
          options = options || {};

          var interview = options.interview;

          var modal = modalbox.open({
            templateUrl: 'app/features/company/interviews/templates/_interview-reject-time-modal.html',
            
            controller: ['$scope', 'modalboxInstance', function ($scope, modalboxInstance) {

              $scope.submit = function () {
                if (!$scope.rejectionComment) return;

                var promise = interview.rejectTime().then(function () {
                  $scope.postComment({
                    body: $scope.rejectionComment
                  });
                });

                loadingTracker.addPromise(promise);

                return promise;
              };

              $scope.postComment = function (comment) {
                return modelize.$request.post('/comments', {
                  resource: 'interview',
                  resourceId: interview.id,
                  comment: comment
                }).then(function () {
                  modalboxInstance.close(interview);
                });
              };

              $scope.isLoading = function () {
                return loadingTracker.active() || interview.$loading;
              };

            }]
          });

          return modal;

        }
      };
    }]);
