'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('candidate.interviews.details', {
        url: '/:interviewId',
        templateUrl: appSettings.appPaths.features + '/candidate/interviews/templates/details.html',

        resolve: {
          interviewId: ['$stateParams', function ($stateParams) {
            return parseInt($stateParams.interviewId);
          }],

          interview: ['modelize', 'interviewId', function (modelize, interviewId) {
            return modelize.one('/candidate').many('interviews').get(interviewId).$future;
          }]
        },

        controllerAs: 'interviewCtrl',

        controller: ['$scope', '$stateParams', 'modalbox', 'interview', 'interviewRejectTimeModal',
          function ($scope, $stateParams, modalbox, interview, interviewRejectTimeModal) {
            $scope.interview = interview;

            $scope.accept = function () {
              $scope.interview.accept();
            };

            $scope.reject = function () {
              $scope.interview.reject();
            };

            $scope.rejectTime = function () {
              interviewRejectTimeModal.open({ interview: $scope.interview }).result.then(function (rejectionData) {
                $scope.interview.rejectTime(rejectionData);
              });
            };

            $scope.showCandidateOptions = function () {
              return interview.canBeAccepted() || interview.canBeRejected() || interview.canBeTimeRejected();
            };
          }]

      })

      .state('candidate.interviews.details.comments', {
        url: '/comments'
      });

  }]);
