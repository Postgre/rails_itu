'use strict';

angular.module('bridge')

  // Reusable candidate resume directive

  /* Example:
   * <div class="content-padded" candidate-resume
   *      candidate="resumeCtrl.candidate"
   *      skill-records="resumeCtrl.skillRecords"
   *      skill-category-records="resumeCtrl.skillCategoryRecords"
   *      employment-records="resumeCtrl.employmentRecords"
   *      education-records="resumeCtrl.educationRecords"></div>
   */

  .directive('candidateResume', [function () {
    return {
      restrict: 'EA',
      templateUrl: 'app/features/shared/candidate-resume/templates/_candidate-resume.html',
      scope: {
        candidate: '=',
        aspect: '=',
        job: '='
        // skillCategoryRecords: '=',
        // skillRecords: '=',
        // employmentRecords: '=',
        // educationRecords: '='
      },
      link: function (scope, el, attrs) {

        scope.isStaffViewing = function () {
          return scope.aspect === 'staff';
        };

        scope.isJobContext = function () {
          return !!scope.job;
        };

        // Note: not using modelizer-specific methods to be more universal

        scope.$watch('candidate', function(newVal) {
          if(angular.isUndefined(newVal)) return;
          scope.skillRecords         = scope.candidate && scope.candidate.skillRecords;
          scope.skillCategoryRecords = scope.candidate && scope.candidate.skillCategoryRecords;
          scope.employmentRecords    = scope.candidate && scope.candidate.employmentRecords;
          scope.educationRecords     = scope.candidate && scope.candidate.educationRecords;
          scope.courses = scope.candidate && _.where(scope.candidate.courses, {isVisible: true});
        });

        scope.anyFeaturedSkills = function () {
          if (!scope.skillRecords || !scope.skillRecords.length) return false;

          for (var i = 0; i < scope.skillRecords.length; i++) {
            if (scope.skillRecords[i].isFeatured) return true;
          }

          return false;
        };

        scope.hasSkillRecords = function (skillCategoryRecord) {
          if (!scope.skillRecords || !skillCategoryRecord) return false;

          for (var i = 0; i < scope.skillRecords.length; i++) {
            if (scope.skillRecords[i].skillCategoryId &&
                scope.skillRecords[i].skillCategoryId === skillCategoryRecord.skillCategoryId) {
              return true;
            }
          }

          return false;
        };

        // Job matching
        scope.getSkillsMatchedCount = function () {
          if (!scope.candidate || !scope.candidate.skillRecords) return 0;

          return _.where(scope.candidate.skillRecords, { matched: true }).length;
        };

        scope.anyMatchedSkills = function () {
          if (!scope.candidate || !scope.candidate.skillRecords) return 0;

          return _.any(scope.candidate.skillRecords, { matched: true });
        };

      }
    };
  }]);
