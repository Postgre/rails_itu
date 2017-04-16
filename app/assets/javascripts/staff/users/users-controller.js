'use strict';

angular.module('bridge').controller('UsersController', ['$scope', '$state', 'FullRespRestangular', 'appUrl', '$window', 'userRoles', 'currentUser', 'become', 'messageService',
    function ($scope, $state, FullRespRestangular, appUrl, $window, userRoles, currentUser, become, messageService) {
        $scope.search = {role: ''};
        $scope.userRoles = userRoles;
        $scope.newMessage = {};

        $scope.getUsers = function getUsers() {
            FullRespRestangular.setBaseUrl('/api/v1/staff').all('users')
            .getList({q: $scope.search, order: $scope.order, reverse: $scope.reverse, page: $scope.page})
            .then(function(response) {
                $scope.users = $scope.users.concat(response.data);
                $scope.usersTotal = parseInt(response.headers('X-total'));
                $scope.usersOffset = parseInt(response.headers('X-offset'));
                $scope.usersLimit = parseInt(response.headers('X-limit'));
            });
        };

        $scope.nextPageAvailable = function nextPageAvailable() {
            return Math.floor($scope.usersTotal / $scope.usersLimit) > ($scope.usersOffset / $scope.usersLimit);
        };

        $scope.reload = function reload() {
            $scope.users = [];
            $scope.page = 1;
            $scope.getUsers();
        };

        $scope.getNextPage = function getNextPage() {
            if(!$scope.nextPageAvailable) return;
            $scope.page += 1;
            $scope.getUsers();
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

        $scope.goToState = function(user) {
          switch(user.roles[0].name) {
            case 'candidate':
              $state.go('candidates.detail', {id: user.candidate_id});
              break;
            case 'representative':
              $state.go('companies.detail', {id: user.roles[0].resource_id});
              break;
            case 'staff':
              break;
          }
        };

        $scope.message = function(user, hideCallback) {
          messageService.send($scope, user, hideCallback);
        };

      $scope.become = function(user) {
        become.become(user);
      };

    }]);
