'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel(['company', 'companies'], {

      // No need for `baseUrl` since its inferred from model name

      name: '',
      logoUrl: null,
      industry: null,
      industryId: null,
      aboutUs: '',
      companySize: 1,
      country: modelize.attr.model({ modelClass: 'country' }),
      countryIso3: '',
      region: '',
      city: '',
      streetAddress: '',
      streetAddress2: '',
      phoneNumber: '',
      state: 'pending',
      isFavorited: false,


      jobs: modelize.attr.collection({ modelClass: 'job' }),

      isJustCreated: function () {
        return this.state === 'created';
      },

      isPending: function () {
        return this.state === 'pending';
      },

      isRejected: function () {
        return this.state === 'rejected';
      },

      isActive: function () {
        return this.state === 'accepted';
      },

      isSuspended: function () {
        return this.state === 'banned';
      },

      fullAddress: function() {
        return _.compact([this.postalCode,
                this.streetAddress,
                this.city,
                this.country.name]).join(', ');
      },

      transformOnSave: function (attrs) {
        // Hack to allow _ before number
        if (attrs.streetAddress2) {
          attrs.streetAddress_2 = attrs.streetAddress2;
          delete attrs.streetAddress2;
        }

        return { company: attrs };
      },

      clearLogo: function () {
        var _this = this;

        return this.$request.delete(this.resourceUrl() + '/logo').then(function () {
          _this.logoUrl = null;
          return true;
        });
      },
      favorite: function (options) {
        options = options || {};
        var _this = this;

        return this.$request.put(options.url || (this.resourceUrl() + '/favorite'), {}, { params: options.params }).then(function () {
          _this.isFavorited = true;
        });
      },

      unfavorite: function (options) {
        options = options || {};
        var _this = this;

        return this.$request.delete(options.url || (this.resourceUrl() + '/favorite'), { params: options.params }).then(function () {
          _this.isFavorited = false;
        });
      }
    });
  }])

  .factory('Company', ['modelize', function (modelize) {
    return modelize('company').$modelClass;
  }]);
