'use strict';

angular.module('bridge').controller('JobDetailController', ['$scope', '$state', 'LoggedRestangular', '$stateParams', 'stringHelper', 'modelize', function( $scope, $state, LoggedRestangular, $stateParams, stringHelper, modelize ) {
  LoggedRestangular.setBaseUrl('/api/v1/staff').one('jobs', $stateParams.id).get().then(function(response) {
      $scope.job = stringHelper.camelizeProperties(response);
  });

  $scope.$watch('job', function(newVal, oldVal) {
    if(angular.isDefined(newVal) && angular.isDefined(newVal.favorited_candidates)) {
      $scope.job = stringHelper.camelizeProperties(newVal);
    }
  });

  $scope.selected = {};

  $scope.$watch('selected.candidate', function(newVal, oldVal) {
    if(angular.isDefined(newVal)) {
      if(_.include(_.map($scope.job.favoritedCandidates, function(c) { return c.id}), newVal.id)) $scope.selected = {};
    }
  });

  $scope.candidateSelected = function() {
    return angular.isObject($scope.selected.candidate);
  };

  $scope.addRecommendation = function() {
    if(!angular.isObject($scope.selected.candidate)) return;
    if($scope.job.state != 'published') return;

    LoggedRestangular.setBaseUrl('/api/v1/staff').setFullResponse(false).one('jobs', $stateParams.id).customOperation('patch', 'recommend', {user_id: $scope.selected.candidate.user_id}).then(function(response) {
      $scope.job.favoritedCandidates.push(stringHelper.camelizeProperties($scope.selected.candidate));
      $scope.selected.candidate = undefined;
    });
  };

  $scope.removeRecommendation = function(candidate) {
    LoggedRestangular.setBaseUrl('/api/v1/staff').one('jobs', $stateParams.id).customDELETE('recommend', {user_id: candidate.userId}).then(function(response) {
      $scope.job.favoritedCandidates = _.without($scope.job.favoritedCandidates, candidate);
    });
  };

  $scope.canBeFlagged = function (job) {
    return job && _.isArray(job.possibleEvents) && _.contains(job.possibleEvents, 'flag');
  };

  $scope.flag = function() {
    LoggedRestangular.setBaseUrl('/api/v1/staff').one('jobs', $stateParams.id).customOperation('patch', 'flag').then(function(response) {
      $scope.job.state = 'flagged';
    });
  }
}]);
