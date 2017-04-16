'use strict';

angular.module('bridge').controller('ApplicationController', ['$scope', '$state', '$rootScope', 'zendeskTicketModal',
  function($scope, $state, $rootScope, zendeskTicketModal) {

    $scope.showZendeskModal = function () {
      zendeskTicketModal.open();
    };
}]);
