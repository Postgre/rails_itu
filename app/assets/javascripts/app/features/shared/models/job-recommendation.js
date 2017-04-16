'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {

    modelize.defineModel('jobRecommendation', {
      baseUrl: '/candidate/jobs/recommended',

      job: modelize.attr.model({ modelClass: 'job' })

    });
  }])

  .factory('JobRecommendation', ['modelize', function (modelize) {
    return modelize('jobRecommendation').$modelClass;
  }]);
