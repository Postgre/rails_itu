'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.education.add', {

      url: '/add',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/education/templates/add.html',

      breadcrumb: {
        label: 'Adding new record'
      },

      controllerAs: 'formCtrl',

      controller: ['$scope', '$state', '$stateParams', 'modelize', 'humanizedMsg',
        function ($scope, $state, $stateParams, modelize, humanizedMsg) {

          this.model = modelize('educationRecords').$new();

          this.create = function (model) {
            return model.save().then(function (educationRecord) {
              humanizedMsg.displayMsg('Successfully created');

              $state.go('candidate.resume.education.list');
            }, function(error) {
              $scope.errors = error.data;
            });
          };

        }]

    });

  }]);
