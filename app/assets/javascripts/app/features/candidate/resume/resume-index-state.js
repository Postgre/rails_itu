'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.index', {

      url: '',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/templates/index.html',

      controllerAs: 'resumeCtrl',

      controller: ['$scope', '$sce', 'modelize', function ($scope, $sce, modelize) {
        var _this = this;

        this.candidate = modelize.one('candidateProfile').get().$future;

        // Skill records

        this.skillCategoryRecords = modelize('candidateSkillCategoryRecords').all().$future;
        this.skillRecords = modelize('candidateSkillRecords').all().$future;

        this.hasSkillRecords = function (skillCategoryRecord) {
          return _this.skillRecords.any({ skillCategoryId: skillCategoryRecord.skillCategoryId });
        };

        // Employment records

        this.employmentRecords = modelize('employmentRecords').all().$future;

        // Education records

        this.educationRecords = modelize('educationRecords').all().$future;

        this.courses = modelize('courses').all().then(function (courses) {
          _this.visibleCourses = _.where(courses, {isVisible: true});
        });

      }]

    });

  }]);
