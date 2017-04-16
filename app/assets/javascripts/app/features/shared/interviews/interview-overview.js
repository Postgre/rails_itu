'use strict';

angular.module('bridge')

  .directive('interviewOverview', ['appSettings', 'uiGmapGoogleMapApi', '$state',
    function (appSettings, uiGmapGoogleMapApi, $state) {

      return {

        restrict: 'EA',
        templateUrl: appSettings.appPaths.features + '/shared/interviews/templates/_interview-overview.html',
        scope: {
          interview: '=',
          company: '=',
          job: '=',
          candidate: '=',
          aspect: '@'
        },

        link: function (scope, el, attrs) {

          scope.isJobContext = function () {
            return !!scope.job;
          };

          scope.isCompanyViewing = function () {
            return scope.aspect === 'company';
          };

          scope.isCandidateViewing = function () {
            return scope.aspect === 'candidate';
          };

          scope.showComments = function () {
            return scope.interview && _.any(scope.interview.comments);
          };

          uiGmapGoogleMapApi.then(function (maps) {
            scope.$watch('interview.latitude', function (newValue) {
              if (!scope.interview || !scope.interview.latitude || !scope.interview.longitude) return;

              var mapStyles = [{"featureType":"administrative","stylers":[{"visibility":"off"}]},{"featureType":"poi","stylers":[{"visibility":"simplified"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"simplified"}]},{"featureType":"water","stylers":[{"visibility":"simplified"}]},{"featureType":"transit","stylers":[{"visibility":"simplified"}]},{"featureType":"landscape","stylers":[{"visibility":"simplified"}]},{"featureType":"road.highway","stylers":[{"visibility":"off"}]},{"featureType":"road.local","stylers":[{"visibility":"on"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"visibility":"on"}]},{"featureType":"water","stylers":[{"color":"#84afa3"},{"lightness":52}]},{"stylers":[{"saturation":-17},{"gamma":0.36}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#3f518c"}]}];
              scope.map = { center: { latitude: scope.interview.latitude, longitude: scope.interview.longitude }, zoom: 16, options: {scrollwheel: false, styles: mapStyles} };
              scope.marker = {coords: { latitude: scope.job.latitude, longitude: scope.job.longitude }};
            });
          });

          // State check helpers

          scope.$state = $state;

          scope.isOverviewTab = function () {
            if (scope.isCandidateViewing()) {
              return $state.is('candidate.interviews.details');
            } else if (scope.isCompanyViewing()) {
              return $state.is('company.job-interview-details');
            } else if (!scope.isCommentsTab()) {
              // To make it default in the unsupported env
              return true;
            }

            return false;
          };

          scope.isCommentsTab = function () {
            if (scope.isCandidateViewing()) {
              return $state.is('candidate.interviews.details.comments');
            } else if (scope.isCompanyViewing()) {
              return $state.is('company.job-interview-details.comments');
            }

            return false;
          };
        }
      };
    }]);
