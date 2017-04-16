'use strict';

angular.module('bridge')

  // Reusable job overview directive

  /* Example:
   * <div class="content-padded" job-overview job="someCtrl.job" company="someCtrl.company"></div>
   */

  .directive('jobOverview', ['uiGmapGoogleMapApi', function (uiGmapGoogleMapApi) {
    return {
      restrict: 'EA',
      templateUrl: 'app/features/shared/jobs/templates/_job-overview.html',
      scope: {
        job: '=',
        company: '=',
        aspect: '@',
        hideHeader: '@'
      },

      link: function (scope, el, attrs) {
        uiGmapGoogleMapApi.then(function (maps) {
          if (!scope.job || !scope.job.latitude || !scope.job.longitude) return;

          var mapStyles = [{"featureType":"administrative","stylers":[{"visibility":"off"}]},{"featureType":"poi","stylers":[{"visibility":"simplified"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"simplified"}]},{"featureType":"water","stylers":[{"visibility":"simplified"}]},{"featureType":"transit","stylers":[{"visibility":"simplified"}]},{"featureType":"landscape","stylers":[{"visibility":"simplified"}]},{"featureType":"road.highway","stylers":[{"visibility":"off"}]},{"featureType":"road.local","stylers":[{"visibility":"on"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"visibility":"on"}]},{"featureType":"water","stylers":[{"color":"#84afa3"},{"lightness":52}]},{"stylers":[{"saturation":-17},{"gamma":0.36}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#3f518c"}]}];
          scope.map = { center: { latitude: scope.job.latitude, longitude: scope.job.longitude }, zoom: 16, options: {scrollwheel: false, styles: mapStyles} };
          scope.marker = {coords: { latitude: scope.job.latitude, longitude: scope.job.longitude }};
        });

        scope.isCandidateViewing = function () {
          return scope.aspect === 'candidate';
        };

        scope.isStaffViewing = function () {
          return scope.aspect === 'staff';
        };
      }
    };
  }]);
