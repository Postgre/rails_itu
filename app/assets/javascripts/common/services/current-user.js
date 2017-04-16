'use strict';

angular.module('bridge')

  .factory('currentUser', ['$window', '$cookies', '$q', 'modelize', 'userAccessToken', 'currentUserJson',
    function ($window, $cookies, $q, modelize, userAccessToken, currentUserJson) {

      var userRoles = [];

      return {

        get isAuthenticated () {
          return angular.isObject(currentUserJson);
        },

        get name () {
          return 'Unknown user';
        },

        get avatarUrl () {
          return '';
        },

        get accessToken () {
          return userAccessToken.get();
        },

        set accessToken (value) {
          userAccessToken.set(value);
        },

        get roles () {
          return userRoles;
        },

        clearSession: function () {
          $window.sessionStorage.clear();
        },

        // Account-related

        getAccount: function () {
          return modelize.one('account').get();
        },

        // Role-related methods

        getRoles: function () {
          var _this = this;

          return this.getAccount().then(function (account) {
            userRoles.length = 0;

            if (account.roles && account.roles.length) {
              account.roles.forEach(function (r) {
                userRoles.push(r);
              });
            }

            return userRoles;
          });
        },

        hasMultipleRoles: function () {
          return userRoles && userRoles.length > 1;
        },

        isInRole: function (roleName) {
          if (!roleName) return false;

          return _.any(userRoles, function (role) {
            return role && role.name === roleName;
          });
        },

        isCandidate: function () {
          return this.isInRole('candidate');
        },

        isCompanyRep: function () {
          return this.isInRole('representative');
        },

        isCompanyAllowed: function (companyId) {
          return _.any(userRoles, function (role) {
            return role && role.name === 'representative' && role.resourceId === companyId;
          });
        },

        isStaff: function () {
          return this.isInRole('staff');
        }

      };

  }]);
