'use strict';

angular.module('bridge')

  .factory('authTokenHttpInterceptor', ['$rootScope', '$q', 'userAccessToken', function ($rootScope, $q, userAccessToken) {

    return {

      request: function (config) {
        config.headers = config.headers || {};

        if (userAccessToken.isValid) {
          config.headers.Authorization = 'Token token=' + userAccessToken.get();
        }

        return config;
      },

      response: function (response) {
        // if (response.status === 401) {
        //   // Handle from here?
        // }

        return response || $q.when(response);
      }

    };

  }]);

angular.module('bridge').config(['$httpProvider', function ($httpProvider) {
  $httpProvider.interceptors.push('authTokenHttpInterceptor');
}]);
