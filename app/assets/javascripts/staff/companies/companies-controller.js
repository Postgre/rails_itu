'use strict';

angular.module('bridge').controller('CompaniesController', ['$scope', '$state', 'FullRespRestangular', 'companyStates', 'stringHelper',
  function( $scope, $state, FullRespRestangular, companyStates, stringHelper) {
    $scope.companyStates = companyStates;
    $scope.search = {state_eq: ''};
    $scope.controlsDisabled = false;

    $scope.getCompanies = function getCompanies() {
        $scope.controlsDisabled = true;
        FullRespRestangular.setBaseUrl('/api/v1/staff').all('companies')
        .getList({q: $scope.search, order: $scope.order, reverse: $scope.reverse, page: $scope.page})
        .then(function(response) {
            $scope.companies = $scope.companies.concat(_.map(response.data, function (item) { return stringHelper.camelizeProperties(item) }));
            $scope.companiesTotal = parseInt(response.headers('X-total'));
            $scope.companiesOffset = parseInt(response.headers('X-offset'));
            $scope.companiesLimit = parseInt(response.headers('X-limit'));
            $scope.controlsDisabled = false;
          }, function() {
            $scope.controlsDisabled = false;
          });
    };

    $scope.nextPageAvailable = function nextPageAvailable() {
        return Math.floor($scope.companiesTotal / $scope.companiesLimit) > ($scope.companiesOffset / $scope.companiesLimit);
    };

    $scope.reload = function reload() {
        $scope.companies = [];
        $scope.page = 1;
        $scope.getCompanies();
    };

    $scope.getNextPage = function getNextPage() {
        if(!$scope.nextPageAvailable) return;
        $scope.page += 1;
        $scope.getCompanies();
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

    $scope.getStateName = function getStateName() {
        return $scope.search.state_eq;
    };

    $scope.reload();
}]);
