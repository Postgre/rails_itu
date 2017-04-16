'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.interviews.edit', {

      url: '/:interviewId/edit',
      templateUrl: appSettings.appPaths.features + '/company/interviews/templates/edit.html',

      breadcrumb: {
        label: 'Editing'
      },

      controllerAs: 'formCtrl',

      controller: ['$scope', '$state', '$stateParams', 'modelize', 'humanizedMsg',
        function ($scope, $state, $stateParams, modelize, humanizedMsg) {

          this.model = modelize.one('company', $stateParams.companyId).one('interviews', $stateParams.interviewId).get().$future;

          this.update = function (model) {
            return model.save().then(function () {
              humanizedMsg.displayMsg('Interview successfully updated');

              $state.go('company.interviews.list');
            }, function(error) {
              $scope.errors = error.data;
            });
          };

        }]

    });

  }]);
