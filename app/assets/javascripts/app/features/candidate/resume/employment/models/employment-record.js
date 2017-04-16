'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('employmentRecord', {
      baseUrl: '/candidate/employment-records',

      companyName: '',
      jobTitle: '',
      country: modelize.attr.model({ modelClass: 'country' }),
      countryIso3: '',
      city: null,
      description: '',
      startDate: null,
      endDate: null,
      isCurrentJob: false
    });
  }])

  .factory('EmploymentRecord', ['modelize', function (modelize) {
    return modelize('employmentRecord').$modelClass;
  }]);
