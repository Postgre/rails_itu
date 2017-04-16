'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('skillRecord', {

      skillId: null,
      skillName: '',
      level: 0,
      yearsOfExperience: 1,
      isFeatured: false,

      // Overridden "save"
      save: function (options) {
        options = options || {};
        var _this = this;

        // Default handling for non-new models
        if (!this.isNew()) return this._super.save.call(this, options);

        return this.$request.post(this.resourceUrl(), this.getAttributes()).then(function (data) {
          // Set correct urlPrefix (same as currently saved skill_record)
          var skillCategoryRecords = modelize('skillCategoryRecords').$newCollection(data, options);
          _.each(skillCategoryRecords, function (skillCategoryRecord) {
            _.each(skillCategoryRecord.skillRecords, function (skillRecord) {
              skillRecord.urlPrefix = _this.urlPrefix;
            });
          });

          return skillCategoryRecords;
        });
      },

      reorder: function (position) {
        return this.$request.patch(this.resourceUrl() + '/reorder', { position: position });
      }

    });
  }])

  .factory('SkillRecord', ['modelize', function (modelize) {
    return modelize('skillRecord').$modelClass;
  }]);
