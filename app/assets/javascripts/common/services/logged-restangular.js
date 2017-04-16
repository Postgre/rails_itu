'use strict';

angular.module('bridge')

  .factory('LoggedRestangular', ['Restangular', 'currentUser', function (Restangular, currentUser) {
    
    var token = 'Token token="' + currentUser.accessToken + '"';
    return Restangular.withConfig(function (RestangularConfigurer) {
      RestangularConfigurer.setDefaultHeaders({'Authorization': token});
    });

  }]);
