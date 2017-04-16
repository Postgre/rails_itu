'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('candidateProfile', {
      baseUrl: '/candidate/profile',

      name: '',
      degree: '',
      about: '',
      country: modelize.attr.model({ modelClass: 'country' }),
      countryId: null,
      countryIso3: '',
      availability: 'available_full_time',
      isVisible: false,

      idAttribute: false,
      courses: modelize.attr.model({ modelClass: 'course' }),

      // TODO: Think how to avoid the need for a hack for "singular-only" resources
      isNew: function () { return false; },

      static: {
        getCurrentProfile: function () {
          var _this = this;

          return this.$request.get(this.baseUrl).then(function (profile) {
            return _this.$new(profile);
          });
        }
      }
    });
  }])

  .factory('CandidateProfile', ['modelize', function (modelize) {
    return modelize('candidateProfile').$modelClass;
  }]);
