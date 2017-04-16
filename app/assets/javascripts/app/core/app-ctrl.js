'use strict';

angular.module('bridge')

  .controller('AppCtrl', ['$scope', '$rootScope', '$state', 'appSettings', 'zendeskTicketModal', '$window', 'currentUser', 'accountService', 'idUrl', 'Restangular',
    function ($scope, $rootScope, $state, appSettings, zendeskTicketModal, $window, currentUser, accountService, idUrl, Restangular) {

      // $rootScope.$on('$stateChangeStart', function (e, toState) {
      //   if ((toState && toState.data && toState.data.requireAuthentication) && !account.isAuthenticated()) {
      //     e.preventDefault();
      //     $state.go('login');
      //   }
      // });

      $scope.hasError = function (field) {
        if(angular.isUndefined($scope.errors)) return false;
        return angular.isDefined(_.find($scope.errors.fieldErrors, function (error) { return error.field === field; }));
      };

      // Zendesk ticket modal activation
      $scope.openZendeskTicketModal = function () {
        zendeskTicketModal.open();
      };

      $scope.logout = function logout() {
        currentUser.clearSession();
        Restangular.one('session').remove().then(function(res) {
          $window.location.replace($scope.logoutUrl);
        });
      };
    }]);
