'use strict';

angular.module('bridge')

  .config(['$httpProvider', function ($httpProvider) {

    $httpProvider.interceptors.push(['$rootScope', '$q', 'stringHelper', function ($rootScope, $q, stringHelper) {

      return {

        request: function (reqConfig) {
          if (reqConfig.data) reqConfig.data = stringHelper.decamelizeProperties(reqConfig.data);
          if (reqConfig.params) reqConfig.params = stringHelper.decamelizeProperties(reqConfig.params);

          return reqConfig;
        },

        response: function (response) {
          if (response.data) response.data = stringHelper.camelizeProperties(response.data);

          return response;
        },

        requestError: function (rejection) {
          if (rejection.data) rejection.data = stringHelper.camelizeProperties(rejection.data);

          console.log('requestError');
          console.log(rejection);

          return $q.reject(rejection);
        },

        responseError: function (response) {
          if (response.data) response.data = stringHelper.camelizeProperties(response.data);

          if (response.status === 422 && response.data.fieldErrors) {
            var fieldErrors = response.data.fieldErrors;

            for (var i = 0; i < fieldErrors.length; i++) {
              if (fieldErrors[i].field) {
                fieldErrors[i].field = stringHelper.camelize(fieldErrors[i].field);
              }
            }
          }

          return $q.reject(response);
        }

      };

    }]);

  }]);
