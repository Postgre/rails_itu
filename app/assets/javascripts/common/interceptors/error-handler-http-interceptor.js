'use strict';

angular.module('bridge')

  .factory('errorHandlerHttpInterceptor', ['$rootScope', '$q', function ($rootScope, $q) {

    return {

      responseError: function (response) {
        $rootScope.$emit('responseError', response);

        return $q.reject(response);
      }

    };

  }]);


angular.module('bridge')

  .run(['$rootScope', 'ngExTopslideErrorMsg', function ($rootScope, topslideErrorMsg) {

    var errorCodeIcons = {
      '401': 'fa-lock',
      '403': 'fa-lock',
      '422': 'fa-paragraph',
      '500': 'fa-power-off'
    };

    $rootScope.$on('responseError', function (e, response) {
      var status    = response.status,
          errorIcon = errorCodeIcons[status],
          errorMessage;

      // To be handled outside the generic handler
      if (status === 422) return;

      if (response.message) {
        errorMessage = response.message;
      } else {
        if (status === 401) errorMessage = 'You need to be authenticated to perform the requested action';
        else if (status === 422) errorMessage = 'Some of the entered data is invalid. Please fix the issues and try again.';
        else if (status === 500) errorMessage = 'Something completely wrong happened at the server. Please contact administrators.';
        else {
          errorMessage = 'Request is unsuccessful';
          errorMessage += response.statusText ? ': ' + response.statusText : ' for some reason';
        }
      }

      // console.log(response);
      var options = {};
      if (errorIcon) options.iconCssClass = errorIcon;
      topslideErrorMsg.show(errorMessage, options);
    });
  }]);

angular.module('bridge').config(['$httpProvider', function ($httpProvider) {
  $httpProvider.interceptors.push('errorHandlerHttpInterceptor');
}]);
