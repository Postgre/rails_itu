'use strict';

angular.module('bridge').controller('CandidateController', ['$scope', '$state', 'LoggedRestangular', '$stateParams', 'stringHelper', 'currentUser', '$window', 'appUrl', 'become', 'messageService',
  function( $scope, $state, LoggedRestangular, $stateParams, stringHelper, currentUser, $window, appUrl, become, messageService ) {
    LoggedRestangular.setBaseUrl('/api/v1/staff').one('candidates', $stateParams.id).get().then(function(data) {
      $scope.candidate = stringHelper.camelizeProperties(data);
    });

    $scope.$watch('candidate', function(newVal, oldVal) {
      if(!newVal || (newVal.user && newVal.user.firstName)) return;
      $scope.candidate = stringHelper.camelizeProperties(newVal);
      $scope.candidate.comments = newVal.comments;
    });

    $scope.message = function(user, hideCallback) {
      messageService.send($scope, user, hideCallback);
    };

    $scope.become = function(user) {
      become.become(user);
    };
}]);
