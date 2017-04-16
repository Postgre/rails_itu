'use strict';

angular.module('bridge')

  .filter('clientMode', ['$filter', function ($filter) {
    return function(collection, mode, search, order, reverse) {
      if (mode == 'client') {
        return $filter('orderBy')($filter('filter')(collection, search, false), order, reverse);
      } else {
        return collection;
      }
    };
  }]);