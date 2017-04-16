'use strict';

angular.module('bridge')

  .factory('notificationDialog', ['modalbox', '$q', function (modalbox, $q) {

    return {
      show: function (options) {
        options = options || {};

        var modal = modalbox.open({
          templateUrl: 'common/components/notification-dialog/templates/_notification-dialog.html',
          
          controller: ['$scope', 'modalboxInstance', function ($scope, modalboxInstance) {
            $scope.title = options.title;
            $scope.text  = options.text;
            $scope.buttonText = options.buttonText || 'OK';
          }]
        });

        return modal.result;
      }
    };

  }]);
