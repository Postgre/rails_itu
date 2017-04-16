'use strict';

angular.module('bridge').factory('become', ['LoggedRestangular', 'currentUser', '$window', 'appUrl',
    function (LoggedRestangular, currentUser, $window, appUrl) {
      return {
        become: function become(user) {
            LoggedRestangular.setBaseUrl('/api/v1/staff').one('users', user.id).customGET('become').then(function (res) {
                currentUser.clearSession();
                $window.location.replace(appUrl);
            });
        }
      };
  }]);
