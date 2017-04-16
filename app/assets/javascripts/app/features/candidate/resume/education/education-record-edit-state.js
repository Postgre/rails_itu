'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.education.edit', {

      url: '/:educationRecordId/edit',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/education/templates/edit.html',

      breadcrumb: {
        label: 'Editing'
      },

      controllerAs: 'formCtrl',

      controller: ['$scope', '$state', '$stateParams', 'modelize', 'humanizedMsg',
        function ($scope, $state, $stateParams, modelize, humanizedMsg) {

          this.model = modelize('educationRecords').get($stateParams.educationRecordId).$future;

          this.update = function (model) {
            return model.save().then(function () {
              humanizedMsg.displayMsg('Successfully updated');

              $state.go('candidate.resume.education.list');
            }, function(error) {
              $scope.errors = error.data;
            });
          };

        }]

    });

  }]);
