'use strict';

angular.module('bridge')

  .directive('companyJobList', ['modelize', function (modelize) {
    return {
      restrict: 'EA',
      templateUrl: 'app/features/shared/companies/templates/_company-job-list.html',
      scope: {
        company: '=',
        aspect: '@'
      },

      link: function (scope, el, attrs) {
        // Aspect helpers
        scope.isCandidateViewing = function () {
          return scope.aspect === 'candidate';
        };

        scope.jobs = modelize.one('company', scope.company.id).many('jobs').all().$future;

        // Schedule filter
        scope.schedule = '';

        scope.filterBySchedule = function (schedule) {
          scope.schedule = schedule;
        };

        scope.clearScheduleFilter = function () {
          scope.schedule = '';
        };

        scope.isSchedule = function (job) {
          if (!scope.schedule) return true;
          return job && (job.schedule === scope.schedule);
        };
      }
    };
  }]);
