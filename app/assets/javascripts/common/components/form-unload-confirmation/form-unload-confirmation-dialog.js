'use strict';

angular.module('bridge')

  .factory('formUnloadConfirmationDialog', ['modalbox', '$q', function (modalbox, $q) {

    return {
      show: function (options) {
        options = options || {};

        var modal = modalbox.open({
          templateUrl: 'common/components/form-unload-confirmation/templates/_form-unload-confirmation-dialog.html',
          
          controller: ['$scope', 'modalboxInstance', function ($scope, modalboxInstance) {
            $scope.message = options.message || 'Are you sure to proceed?';

            $scope.confirm = function () {
              modalboxInstance.close();
            };
          }]
        });

        return modal.result;
      }
    };

  }]);
