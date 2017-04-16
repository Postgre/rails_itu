'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.education.list', {

      url: '',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/education/templates/list.html',
      controllerAs: 'listCtrl',

      controller: ['$scope', '$sce', 'modelize', 'humanizedMsg',
        function ($scope, $sce, modelize, humanizedMsg) {

          this.educationRecords = modelize('educationRecords').all().$future;
          this.courses = modelize('courses').all().$future;

          this.delete = function (educationRecord) {
            educationRecord.destroy().then(function () {
              humanizedMsg.displayMsg('Deleted successfully');
            });
          };

        }]

    });

  }]);
