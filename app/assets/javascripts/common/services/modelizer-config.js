'use strict';

angular.module('bridge')

  .config(['modelizeProvider', function (modelizeProvider) {

    modelizeProvider.parseModelErrors = function (responseData, options) {
      return (responseData && _.isObject(responseData)) ? responseData : null;
    };

  }]);
