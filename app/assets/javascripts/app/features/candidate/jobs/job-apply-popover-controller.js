'use strict';

angular.module('bridge')

  .controller('JobApplyPopoverController', ['$scope', '$timeout', '$stateParams', '$upload', 'humanizedMsg',
    function ($scope, $timeout, $stateParams, $upload, humanizedMsg) {
      $scope.model = {};
      $timeout(function () {
        $('input[type=file]').bootstrapFileInput();
      }, 50);

      $scope.submit = function (hideCallback) {
        $upload.upload({
          url: '/api/v1/candidate/jobs/' + $stateParams.jobId + '/applications',
          method: 'POST',
          data: {cover_letter: $scope.model.cover_letter},
          file: $scope.model.resume_file,
          fileFormDataName: 'resume'
        }).progress(function (evt) {
          console.log('progress: ' + parseInt(100.0 * evt.loaded / evt.total) + '% file :' + evt.config.file.name);
        }).success(function (data, status, headers, config) {
          // file is uploaded successfully
          console.log('file ' + config.file.name + 'is uploaded successfully. Response: ' + data);
          $scope.job.isApplied = true;
          humanizedMsg.displayMsg('Your application has been successfully submitted');
          hideCallback();
        });
      }
    }]);
