'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('educationRecord', {
      baseUrl: '/candidate/education-records',

      country: modelize.attr.model({ modelClass: 'country' }),
      courses: modelize.attr.collection({ modelClass: 'course' }),
      countryIso3: '',
      city: '',
      school: '',
      degree: '',
      fieldOfStudy: '',
      startYear: null,
      endYear: null,
      isVerified: false,
      hasGraduated: false
    });
  }])

  .factory('EducationRecord', ['modelize', function (modelize) {
    return modelize('educationRecord').$modelClass;
  }]);
