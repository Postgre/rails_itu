'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.employment.edit', {

      url: '/:employmentRecordId/edit',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/employment/templates/edit.html',

      breadcrumb: {
        label: 'Editing'
      },

      controllerAs: 'formCtrl',

      controller: ['$scope', '$state', '$stateParams', 'modelize', 'humanizedMsg',
        function ($scope, $state, $stateParams, modelize, humanizedMsg) {

          this.model = modelize('employmentRecords').get($stateParams.employmentRecordId).$future;

          this.update = function (model) {
            return model.save().then(function () {
              humanizedMsg.displayMsg('Successfully updated');

              $state.go('candidate.resume.employment.list');
            }, function(error) {
              $scope.errors = error.data;
            });
          };

        }]

    });

  }]);
