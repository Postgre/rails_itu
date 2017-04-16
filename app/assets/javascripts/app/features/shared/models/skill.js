'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('skill', {
      baseUrl: '/skills',

      name: '',

      static: {
        search: function (searchString, skillCategoryId) {
          return this.$request.get(this.baseUrl + '/search', { params: { s: searchString, skillCategoryId: skillCategoryId } });
        },

        searchForCategories: function (searchString, skillCategoryIds) {
          return this.$request.get(this.baseUrl, { params: { query: searchString, categoryIds: skillCategoryIds } });
        }
      }
    });
  }])

  .factory('Skill', ['modelize', function (modelize) {
    return modelize('skill').$modelClass;
  }]);
