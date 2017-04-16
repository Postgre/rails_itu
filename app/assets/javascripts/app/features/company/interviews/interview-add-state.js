'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.interviews.invite', {

      url: '/invite/:candidateId',
      templateUrl: appSettings.appPaths.features + '/company/interviews/templates/invite.html',

      breadcrumb: {
        label: 'Invitation'
      },

      resolve: {
        candidate: ['$stateParams', 'modelize', function ($stateParams, modelize) {
          return modelize.one('candidate', parseInt($stateParams.candidateId)).get().$future;
        }]
      },

      controllerAs: 'formCtrl',

      controller: ['$scope', '$state', '$stateParams', 'modelize', 'candidate', 'humanizedMsg',
        function ($scope, $state, $stateParams, modelize, candidate, humanizedMsg) {

          this.model = modelize('interviews').$new({ candidate: candidate });

          this.create = function (model) {
            return model.save().then(function () {
              humanizedMsg.displayMsg('Interview successfully created');

              $state.go('company.interviews.list');
            }, function(error) {
              $scope.errors = error.data;
            });
          };

        }]

    });

  }]);
