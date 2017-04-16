'use strict';

angular.module('bridge')

  .filter('nl2br', function () {
    return function (str) {
      if (!str) return str;

      return str.replace(/\n/g, '<br>');
    };
  })

  .filter('trustedHtml', ['$sce', function ($sce) {
    return function (str) {
      if (!str) return str;

      return $sce.trustAsHtml(str);
    };
  }]);
