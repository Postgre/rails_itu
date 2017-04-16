'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.employment.add', {

      url: '/add',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/employment/templates/add.html',

      breadcrumb: {
        label: 'Adding new position'
      },

      controllerAs: 'formCtrl',

      controller: ['$scope', '$state', '$q', '$stateParams', 'modelize', 'humanizedMsg',
        function ($scope, $state, $q, $stateParams, modelize, humanizedMsg) {

          this.model = modelize('employmentRecord').$new();

          this.create = function (model, options) {
            return model.save(options).then(function (employmentRecord) {
              humanizedMsg.displayMsg('Successfully created');

              $state.go('candidate.resume.employment.list');

              return employmentRecord;
            });
          };

        }]

    });

  }]);
