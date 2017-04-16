'use strict';

angular.module('bridge')

  .directive('userAvatarSquare', function () {

    // Note: Staff-only currently because of inconsistent casing

    return {
      restrict: 'EA',
      templateUrl: 'common/components/user-avatar/templates/_user-avatar-square.html',
      replace: true,
      scope: {
        user: '='
      }
    };

  });
