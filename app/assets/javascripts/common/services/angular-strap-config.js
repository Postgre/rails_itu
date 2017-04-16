'use strict';

angular.module('bridge')

  .config(['$selectProvider', function ($selectProvider) {

    _.extend($selectProvider.defaults, {
      iconCheckmark: 'fa fa-check'
    });

  }]);
