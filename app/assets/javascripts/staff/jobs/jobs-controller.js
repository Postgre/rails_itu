'use strict';

angular.module('bridge').controller('JobsController', ['$scope', '$state', '$stateParams', 'FullRespRestangular', 'jobStates', 'stringHelper', function( $scope, $state, $stateParams, FullRespRestangular, jobStates, stringHelper) {
  $scope.jobStates = jobStates;
  if($stateParams.companyId > '') {
    $scope.search = {company_id_eq: $stateParams.companyId};
  } else {
    $scope.search = {};
  }
  $scope.controlsDisabled = false;

  FullRespRestangular.extendModel('jobs', function(model) {
    if(angular.isObject(model)) {
      model.isPublished = function() {
        return this.state === 'published';
      };
    }
    return model;
  });

  $scope.getJobs = function getJobs() {
    $scope.controlsDisabled = true;

    FullRespRestangular.setBaseUrl('/api/v1/staff').all('jobs')
    .getList({ q: $scope.search, order: $scope.order, reverse: $scope.reverse, page: $scope.page })
    .then(function (response) {
      $scope.jobs = $scope.jobs.concat(_.map(response.data, function (item) { return stringHelper.camelizeProperties(item) }));
      $scope.jobsTotal = parseInt(response.headers('X-total'));
      $scope.jobsOffset = parseInt(response.headers('X-offset'));
      $scope.jobsLimit = parseInt(response.headers('X-limit'));
    }).finally(function () {
      $scope.controlsDisabled = false;
    });
  };

  $scope.nextPageAvailable = function nextPageAvailable() {
    return Math.floor($scope.jobsTotal / $scope.jobsLimit) > ($scope.jobsOffset / $scope.jobsLimit);
  };

  $scope.reload = function reload() {
    $scope.jobs = [];
    $scope.page = 1;
    $scope.getJobs();
  };

  $scope.getNextPage = function getNextPage() {
    if(!$scope.nextPageAvailable) return;
    $scope.page += 1;
    $scope.getJobs();
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
