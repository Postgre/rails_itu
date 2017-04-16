'use strict';

angular.module('bridge').controller('CandidatesController', ['$scope', '$state', 'FullRespRestangular', function( $scope, $state, FullRespRestangular ) {
    $scope.search = {};
    $scope.order = "users.last_name";
    $scope.controlsDisabled = false;

    $scope.getCandidates = function getCandidates() {
        $scope.controlsDisabled = true;
        FullRespRestangular.setBaseUrl('/api/v1/staff').all('candidates')
        .getList({q: $scope.search, order: $scope.order, reverse: $scope.reverse, page: $scope.page})
        .then(function(response) {
            $scope.candidates = $scope.candidates.concat(response.data);
            $scope.candidatesTotal = parseInt(response.headers('X-total'));
            $scope.candidatesOffset = parseInt(response.headers('X-offset'));
            $scope.candidatesLimit = parseInt(response.headers('X-limit'));
            $scope.controlsDisabled = false;
          }, function() {
            $scope.controlsDisabled = false;
          });
    };

    $scope.nextPageAvailable = function nextPageAvailable() {
        return Math.floor($scope.candidatesTotal / $scope.candidatesLimit) > ($scope.candidatesOffset / $scope.candidatesLimit);
    };

    $scope.reload = function reload() {
        $scope.candidates = [];
        $scope.page = 1;
        $scope.getCandidates();
    };

    $scope.getNextPage = function getNextPage() {
        if(!$scope.nextPageAvailable) return;
        $scope.page += 1;
        $scope.getCandidates();
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
