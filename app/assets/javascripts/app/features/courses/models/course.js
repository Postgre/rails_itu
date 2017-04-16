'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('course', {
      baseUrl: '/candidate/courses',

      candidateId: null,
      educationRecordId: null,
      title: '',
      description: '',
      semester: '',
      professor: '',
      department: '',
      isVisible: true
    });
  }])

  .factory('Course', ['modelize', function (modelize) {
    return modelize('course').$modelClass;
  }]);
