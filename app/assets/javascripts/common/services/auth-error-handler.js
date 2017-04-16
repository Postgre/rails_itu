'use strict';

angular.module('bridge')

  .run(['$rootScope', '$window', 'idUrl', function ($rootScope, $window, idUrl) {
    $rootScope.$on('responseError', function (e, response) {
      if (response.status !== 401) return;

      // Simply redirect user to ID login
      $window.location.href = idUrl + '/login';
    });
  }]);
