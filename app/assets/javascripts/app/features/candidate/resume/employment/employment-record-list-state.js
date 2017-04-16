'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.employment.list', {

      url: '',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/employment/templates/list.html',
      controllerAs: 'listCtrl',

      controller: ['$scope', '$sce', 'modelize', 'humanizedMsg',
        function ($scope, $sce, modelize, humanizedMsg) {

          this.employmentRecords = modelize('employmentRecords').all().$future;

          this.delete = function (employmentRecord) {
            employmentRecord.destroy().then(function () {
              humanizedMsg.displayMsg('Deleted successfully');
            });
          };

        }]

    });

  }]);
