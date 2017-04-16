'use strict';

angular.module('bridge')

  // Reusable company summary directive

  /* Example:
   * <div class="content-padded" company-summary company="someCtrl.company"></div>
   */

  .directive('companySummary', [function () {
    return {
      restrict: 'EA',
      templateUrl: 'app/features/shared/companies/templates/_company-summary.html',
      scope: {
        company: '=',
        aspect: '@'
      },

      link: function (scope, el, attrs) {
        scope.isCandidateViewing = function () {
          return scope.aspect === 'candidate';
        };
      }
    };
  }]);
