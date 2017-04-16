'use strict';

angular.module('bridge')

  .directive('jobListItem', ['humanizedMsg', 'modelize',
    function (humanizedMsg, modelize) {

      return {

        restrict: 'EA',
        replace: true,
        templateUrl: 'app/features/shared/jobs/templates/_job-list-item.html',
        scope: {
          job: '=',
          company: '=',
          aspect: '@',
          recommendedBy: '=',
          readonly: '=',
          skillFilterLinks: '@',
          hideCompanyName: '@'
        },

        link: function (scope, el, attrs) {
          scope.isCandidateViewing = function () {
            return scope.aspect === 'candidate';
          };

          scope.isStaffViewing = function () {
            return scope.aspect === 'staff';
          };

          scope.needToShowFavorited = function() {
            return (_.size(scope.job.favoritedCandidates) > 0) && scope.isStaffViewing();
          };

          scope.favoritedCount = function() {
            return _.size(scope.job.favoritedCandidates);
          };

          scope.isCompanyViewing = function () {
            // Company aspect is default
            return !scope.aspect || scope.aspect === 'company';
          };

          scope.toggleFavoriteAsCandidate = function (job) {
            if(job.isFavorited) {
              job.unfavorite({ url: modelize.one('candidateJob', job.id).resourceUrl() + '/favorite' });
            } else {
              job.favorite({ url: modelize.one('candidateJob', job.id).resourceUrl() + '/favorite' });
            }
          };

        }

      };

    }]);
