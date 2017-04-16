'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('companyProfile', {
      baseUrl: '/company/profile',

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

      idAttribute: false,
      // TODO: Think how to avoid the need for a hack for "singular-only" resources
      isNew: function () { return false; },

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

        return this.$request.delete(this.baseUrl + '/logo').then(function () {
          _this.logoUrl = null;
          return true;
        });
      },

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

  .factory('CompanyProfile', ['modelize', function (modelize) {
    return modelize('companyProfile').$modelClass;
  }]);
