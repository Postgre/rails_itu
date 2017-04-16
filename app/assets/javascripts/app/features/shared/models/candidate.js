'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {

    modelize.defineModel('candidate', {
      name: '',
      avatarUrl: '',
      degree: '',
      about: '',
      city: '',
      country: modelize.attr.model({ modelClass: 'country' }),
      countryId: null,
      availability: 'available_full_time',
      isVisible: true,
      skillCategoryRecords: modelize.attr.collection({ modelClass: 'skillCategoryRecords' }),
      skillRecords: modelize.attr.collection({ modelClass: 'skillRecords' }),

      // Current (company) user context
      pendingInterviews: modelize.attr.collection({ modelClass: 'interviews' }),
      isHired: false,
      isFavorite: false,

      favorite: function (params) {
        var _this = this;
        return this.$request.put(this.resourceUrl() + '/favorite', {}, { params: params }).then(function () {
          _this.isFavorite = true;
        });
      },

      unfavorite: function (params) {
        var _this = this;
        return this.$request.delete(this.resourceUrl() + '/favorite', { params: params }).then(function () {
          _this.isFavorite = false;
        });
      },

      static: {
        getFavorites: function () {
          return this.$request.get(this.baseUrl + '/favorites');
        },

        suggestSearch: function (searchStr) {
          return this.$request.get(this.baseUrl + '/search/suggest', { params: { query: searchStr } });
        },

        search: function (searchStr, options) {
          options = options || {};
          options.params = options.params || {};
          options.params.query = searchStr;

          return this.$request.get(this.baseUrl + '/search', options);
        }
      },

      collection: {
        fetchFavorites: function (options) {
          return this.fetch(_.extend({ url: this.modelClass.baseUrl + '/favorites' }, options));
        }
      }
    });

  }])

  .factory('Candidate', ['modelize', function (modelize) {
    return modelize('candidate').$modelClass;
  }]);
