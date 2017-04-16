'use strict';

angular.module('bridge')

  .factory('userAccessToken', ['$window', '$cookies', function ($window, $cookies) {

    var accessTokenCookieName = 'access_token_cookie';

    var _setAccessToken = function (accessToken) {
      $window.sessionStorage.setItem('access_token', accessToken);
    } ;

    return {

      get isValid () {
        return !!this.get();
      },

      get: function () {
        // Tries to get the access_token from either sessionStorage or falls back
        // to reading the cookie (`access_token_cookie`) and sets that to sessionStorage as value.
        var token = $cookies[accessTokenCookieName];
        if (!token) {
          token = $window.sessionStorage.getItem('access_token');
          if (token) _setAccessToken(token);
        }

        return token;
      },

      set: function (value) {
        _setAccessToken(value);
      },

      clear: function () {
        $window.sessionStorage.removeItem('access_token');
      }

    };

  }]);
