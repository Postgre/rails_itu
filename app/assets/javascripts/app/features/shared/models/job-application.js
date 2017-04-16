'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {

    modelize.defineModel('jobApplication', {
      baseUrl: '/applications',

      candidate: modelize.attr.model({ modelClass: 'candidate' })
    });
  }])

  .factory('JobApplication', ['modelize', function (modelize) {
    return modelize('jobApplication').$modelClass;
  }]);
