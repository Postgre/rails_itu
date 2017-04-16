'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.dashboard', {

      url: '',
      templateUrl: appSettings.appPaths.features + '/company/templates/dashboard.html',
      breadcrumb: {
        label: 'Dashboard'
      },

      resolve: {
        // TODO: Think about how to DRY this re-resolve construct
        company: ['$state', '$q', 'company', function ($state, $q, company) {
          if (!company.isActive()) {
            $state.go('company.sign-up', { companyId: company.id });
            return $q.reject();
          }

          return company;
        }]
      },

      controller: ['$scope', '$sce', 'modelize', 'company', '$upload', '$timeout', '$state',
        function ($scope, $sce, modelize, company, $upload, $timeout, $state) {
          $scope.company = company;

          // Logo uploading functionality

          $scope.selectedFile = null;
          $scope.isFileUploading = false;
          $scope.fileUploaded = false;
          $scope.uploadProgress = 0;

          $scope.onFileSelected = function (files) {
            $scope.selectedFile = files[0];
          };

          $scope.uploadFile = function ($popoverScope) {
            if (!$scope.selectedFile) return;

            $popoverScope.$hide();
            $scope.isFileUploading = true;
            
            $upload.upload({
              method: 'PUT',
              url: company.resourceUrl() + '/logo',
              file: $scope.selectedFile
            })
            .success(function (data, status, headers, config) {
              $scope.fileUploaded = true;
              $scope.company.logoUrl = data.logoUrl;
            })
            .progress(function (e) {
              $scope.uploadProgress = parseInt(100.0 * e.loaded / e.total);
            })
            .finally(function () {
              $scope.isFileUploading = false;
              $scope.selectedFile = null;
            });
          };

          $scope.$watch('fileUploaded', function (isUploaded) {
            // When uploaded - show for some time to report, then change the state
            if (isUploaded) {
              $timeout(function () {
                $scope.fileUploaded = false;
                $scope.uploadProgress = 0;
              }, 3000);
            }
          });

          $scope.cancelLogoUpdate = function ($popoverScope) {
            $scope.selectedFile = null;
            $popoverScope.$hide();
          };

        }]

    });

  }]);
