'use strict';

angular.module('bridge').controller('SkillsController', ['$scope', '$state', 'FullRespRestangular', function( $scope, $state, FullRespRestangular) {
  $scope.search = {};
  $scope.controlsDisabled = false;

  $scope.getSkills = function getSkills() {
      $scope.controlsDisabled = true;
      FullRespRestangular.setBaseUrl('/api/v1/staff').setFullResponse(true).all('skills')
      .getList({q: $scope.search, order: $scope.order, reverse: $scope.reverse, page: $scope.page})
      .then(function(response) {
          $scope.skills = $scope.skills.concat(response.data);
          $scope.skillsTotal = parseInt(response.headers('X-total'));
          $scope.skillsOffset = parseInt(response.headers('X-offset'));
          $scope.skillsLimit = parseInt(response.headers('X-limit'));
          $scope.controlsDisabled = false;
        }, function() {
          $scope.controlsDisabled = false;
        });
  };

  $scope.nextPageAvailable = function nextPageAvailable() {
      return Math.floor($scope.skillsTotal / $scope.skillsLimit) > ($scope.skillsOffset / $scope.skillsLimit);
  };

  $scope.reload = function reload() {
      $scope.skills = [];
      $scope.page = 1;
      $scope.getSkills();
  };

  $scope.getNextPage = function getNextPage() {
      if(!$scope.nextPageAvailable) return;
      $scope.page += 1;
      $scope.getSkills();
  };

  $scope.reverse = false;

  $scope.setOrder = function setOrder(name) {
      if($scope.order == name) {
          $scope.reverse = !$scope.reverse;
      } else {
          $scope.order = name
      }
      $scope.reload();
  };

  $scope.reload();
}]);
