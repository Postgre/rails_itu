'use strict';

angular.module('bridge')

  .factory('apiUrlHttpInterceptor', ['$rootScope', '$q', 'apiUrl', function ($rootScope, $q, apiUrl) {

    var shouldPrependApiUrl = function (reqConfig) {
      if (!apiUrl) return false;
      return !(/[\s\S]*.html/.test(reqConfig.url) || (reqConfig.url.indexOf('http') === 0) ||
              (reqConfig.url && reqConfig.url.indexOf(apiUrl) === 0));
    };

    return {

      request: function (reqConfig) {
        // Filter out requests for .html templates, etc
        if (apiUrl && shouldPrependApiUrl(reqConfig)) {
          reqConfig.url = apiUrl + reqConfig.url;
        }

        return reqConfig;
      }

    };

  }]);

angular.module('bridge').config(['$httpProvider', function ($httpProvider) {
  $httpProvider.interceptors.push('apiUrlHttpInterceptor');
}]);
