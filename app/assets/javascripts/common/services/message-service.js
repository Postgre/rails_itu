'use strict';

angular.module('bridge').factory('messageService', ['LoggedRestangular', 'currentUser', '$window', 'appUrl',
    function (LoggedRestangular, currentUser, $window, appUrl) {
      return {
        send: function ($scope, user, hideCallback) {
          LoggedRestangular.setBaseUrl('/api/v1').all('conversations')
            .post({body: $scope.newMessage.body, subject: $scope.newMessage.subject}, {user_id: user.id})
            .then(function (res) {
              $scope.newMessage = {};
              hideCallback();
            });
        }
      };
  }]);
