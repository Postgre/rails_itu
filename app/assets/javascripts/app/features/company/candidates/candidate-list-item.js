'use strict';

angular.module('bridge')
  .directive('candidateListItem', ['humanizedMsg', 'LoggedRestangular', function (humanizedMsg, LoggedRestangular) {
    return {
      restrict: 'EA',
      templateUrl: 'app/features/company/candidates/templates/_candidate-list-item.html',
      scope: {
        aspect: '@',
        candidate: '=',
        company: '=',
        job: '=',
        application: '=',
      },

      link: function (scope, el, attrs) {
        scope.isJobContext = function () {
          return scope.job && scope.job.id && true;
        };

        scope.reject = function() {
          LoggedRestangular.one('companies', scope.company.id).one('jobs', scope.job.id)
            .one('job_applications', scope.application.id).customOperation('patch', 'reject').then(function() {
              scope.application.state = 'rejected';
            });
        };

        scope.acceptApplication = function() {
          if (!scope.application) return;
          scope.application.state = 'accepted';
        };

        scope.isStaffViewing = function() {
          return scope.aspect === 'staff';
        };
      }
    };
  }]);
