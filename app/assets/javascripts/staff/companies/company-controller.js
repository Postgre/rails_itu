'use strict';

angular.module('bridge').controller('CompanyController', ['$scope', '$state', 'LoggedRestangular', '$stateParams', 'stringHelper', 'appUrl', 'currentUser', '$window', 'become',
  function( $scope, $state, LoggedRestangular, $stateParams, stringHelper, appUrl, currentUser, $window, become ) {
    LoggedRestangular.setBaseUrl('/api/v1/staff').one('companies', $stateParams.id).get().then(function(response) {
        $scope.company = stringHelper.camelizeProperties(response);
    });

    $scope.accept = function accept(company) {
        LoggedRestangular.setBaseUrl('/api/v1/staff').one('companies', company.id).customPUT({},'accept').then(function() {
            company.state = 'accepted';
        });
    };

    $scope.reject = function reject(company) {
        LoggedRestangular.setBaseUrl('/api/v1/staff').one('companies', company.id).customPUT({},'reject').then(function() {
            company.state = 'rejected';
        });
    };

    $scope.ban = function ban(company) {
        LoggedRestangular.setBaseUrl('/api/v1/staff').one('companies', company.id).customPUT({},'ban').then(function() {
            company.state = 'banned';
        });
    };

    $scope.unban = function unban(company) {
        LoggedRestangular.setBaseUrl('/api/v1/staff').one('companies', company.id).customPUT({},'unban').then(function() {
            company.state = 'accepted';
        });
    };

    $scope.become = function(user) {
      become.become(user);
    };

}]);
