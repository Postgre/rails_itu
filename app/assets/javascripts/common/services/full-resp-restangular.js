'use strict';

angular.module('bridge').factory('FullRespRestangular', ['Restangular', function (Restangular) {
  return Restangular.withConfig(function(RestangularConfigurer) {
    RestangularConfigurer.setFullResponse(true);
  });
}]);