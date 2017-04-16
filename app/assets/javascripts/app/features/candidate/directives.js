'use strict';

angular.module('bridge')

  // Company overview for candidate (opens in modalbox)

  .directive('candidateCompanyModalOpen', ['modalbox', 'appSettings', function (modalbox, appSettings) {
    return {
      restrict: 'EA',
      link: function (scope, el, attrs) {
        var unbindClickHandler = el.on('click', function (e) {
          e.preventDefault();

          modalbox.open({
            templateUrl: appSettings.appPaths.features + '/candidate/templates/interviews/company-details-modal.html'
          });
        });

        scope.$on('$destroy', function () {
          unbindClickHandler();
        });
      }
    };
  }]);
