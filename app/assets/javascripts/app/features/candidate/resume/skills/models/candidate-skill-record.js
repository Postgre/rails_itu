'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('candidateSkillRecord', {
      baseUrl: '/candidate/skill-records',

      skillId: null,
      skillName: '',
      level: 0,
      yearsOfExperience: 1,
      isFeatured: false,

      reorder: function (position) {
        return this.$request.patch(this.resourceUrl() + '/reorder', { position: position });
      },

      static: {
        getFeatured: function () {
          var _this = this;

          return this.$request.get('/candidate/skill-records/featured').then(function (data) {
            return _this.$newCollection(data);
          });
        }
      }
    });
  }])

  .factory('CandidateSkillRecord', ['modelize', function (modelize) {
    return modelize('candidateSkillRecord').$modelClass;
  }]);
