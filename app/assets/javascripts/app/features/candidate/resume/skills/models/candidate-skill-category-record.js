'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('candidateSkillCategoryRecord', {
      baseUrl: '/candidate/skill-category-records',

      skillCategoryId: null,
      skillCategoryName: '',
      skillRecords: modelize.attr.collection({
        modelClass: 'candidateSkillRecord',
        urlPrefix: function (parentModel) {
          // Since skill-records share the prefix
          // with skill-category-records in all cases,
          // we can just normalize the `urlPrefix`
          // even for contained `skillRecords`
          return parentModel.urlPrefix;
        }
      }),

      reorder: function (position) {
        return this.$request.patch(this.resourceUrl() + '/reorder', { position: position });
      },

      static: {
        getTree: function () {
          var _this = this;

          return this.$request.get('/candidate/skill-records/tree').then(function (data) {
            return _this.$newCollection(data);
          });
        },

        // This method is needed due to non-standard responses and possible tree updates
        // so POST to /skill-records doesn't return a single resource only but the entire tree instead

        addSkillRecord: function (skillRecordData) {
          var _this = this;

          return this.$request.post('/candidate/skill-records', skillRecordData).then(function (data) {
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

  .factory('CandidateSkillCategoryRecord', ['modelize', function (modelize) {
    return modelize('candidateSkillCategoryRecord').$modelClass;
  }]);
