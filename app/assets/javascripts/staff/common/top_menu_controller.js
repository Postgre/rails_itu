'use strict';

angular.module('bridge').controller('TopMenuController', ['$scope', 'Restangular', '$state', '$modal', 'accountService', '$window', 'currentUser', 'idUrl',
    function ($scope, Restangular, $state, $modal, accountService, $window, currentUser, idUrl) {
        $scope.accountService = accountService;
        $scope.$state = $state;

        $scope.logout = function logout() {
            currentUser.clearSession();
            Restangular.one('session').remove().then(function(res) {
              if(angular.isObject(res)) {
                $window.location.replace('/');
              } else {
                $window.location.replace(idUrl + '/sign-out');
              }
            });
        }
}]);
