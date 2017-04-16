'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel(['skillCategory', 'skillCategories'], {
      baseUrl: '/skill-categories',

      name: ''
    });
  }])

  .factory('SkillCategory', ['modelize', function (modelize) {
    return modelize('skillCategory').$modelClass;
  }]);
