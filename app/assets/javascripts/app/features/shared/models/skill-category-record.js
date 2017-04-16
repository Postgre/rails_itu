'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('skillCategoryRecord', {

      skillCategoryId: null,
      skillCategoryName: '',
      skillRecords: modelize.attr.collection({
        modelClass: 'skillRecord',
        urlPrefix: function (parentModel) {
          // Since skill-records share the prefix
          // with skill-category-records in all cases,
          // we can just normalize the `urlPrefix`
          // even for contained `skillRecords`
          return parentModel.urlPrefix;
        }
      }),

      initialize: function (options) {
        var _this = this;

        _.each(this.skillRecords, function (item) {
          item.urlPrefix = _this.urlPrefix;
        });
      },

      reorder: function (position) {
        return this.$request.patch(this.resourceUrl() + '/reorder', { position: position });
      },

      static: {
        getTree: function () {
          var _this = this;

          return this.$request.get(this.urlPrefix + '/' + this.baseUrl + '/tree').then(function (data) {
            return _this.$newCollection(data);
          });
        }
      },

      collection: {
        // Remove the skillCategoryRecord without any 'skillRecord's
        removeEmpty: function () {
          for (var i = 0; i < this.models.length; i++) {
            if (!this.models[i].skillRecords.any()) {
              this.remove(this.models[i]);
            }
          }
        }
      }

    });
  }])

  .factory('SkillCategoryRecord', ['modelize', function (modelize) {
    return modelize('skillCategoryRecord').$modelClass;
  }]);
