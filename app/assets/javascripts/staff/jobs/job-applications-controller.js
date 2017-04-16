'use strict';

angular.module('bridge').controller('JobApplicationsController', ['$scope', '$state', 'LoggedRestangular', '$stateParams', 'stringHelper', 'modelize', function( $scope, $state, LoggedRestangular, $stateParams, stringHelper, modelize ) {
  LoggedRestangular.setBaseUrl('/api/v1/staff').one('jobs', $stateParams.id).all('applications').getList().then(function(response) {
      $scope.applications = stringHelper.camelizeProperties(response);
  });
}]);
