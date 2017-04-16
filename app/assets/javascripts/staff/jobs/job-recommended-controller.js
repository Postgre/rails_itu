'use strict';

angular.module('bridge').controller('JobRecommendedController', ['$scope', '$state', 'LoggedRestangular', '$stateParams', 'stringHelper', 'modelize', function( $scope, $state, LoggedRestangular, $stateParams, stringHelper, modelize ) {
  LoggedRestangular.setBaseUrl('/api/v1/staff').one('jobs', $stateParams.id).all('recommended').getList().then(function(response) {
      $scope.recommendations = stringHelper.camelizeProperties(response);
  });
}]);
