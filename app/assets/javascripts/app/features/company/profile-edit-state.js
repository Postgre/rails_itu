'use strict';

angular.module('bridge.app')

  .config(['$stateProvider', 'appSettings', 'countries', function ($stateProvider, appSettings, countries) {

    $stateProvider.state('company.profile.edit', {

      url: '/edit',
      templateUrl: appSettings.appPaths.features + '/company/templates/profile/edit.html',

      breadcrumb: {
        label: 'Edit company profile'
      },

      controller: ['$scope', '$state', 'modelize', 'company', 'humanizedMsg', '$timeout', '$upload', 'promiseTracker', 'notificationDialog',
        function ($scope, $state, modelize, company, humanizedMsg, $timeout, $upload, promiseTracker, notificationDialog) {

          var loadingTracker = promiseTracker(),
              promise;

          $scope.model = company.clone();

          // Load reference lists data
          $scope.countries = countries;

          // Regions
          $scope.regions = [];

          // Initial regions fetch
          if ($scope.model.countryIso3) {
            promise = modelize('/countries/' + $scope.model.countryIso3 + '/regions').all();
            loadingTracker.addPromise(promise);

            promise.then(function (regions) {
              $scope.regions = regions;
            });
          }

          $scope.$watch('model.countryIso3', function (countryIso3, oldCountryIso3) {
            if (countryIso3 === oldCountryIso3) return;

            $scope.regions = [];
            if (!countryIso3) $scope.model.region = null;

            if (countryIso3) {
              var regionsPromise = modelize('/countries/' + countryIso3 + '/regions').all();
              loadingTracker.addPromise(regionsPromise);

              regionsPromise.then(function (regions) {
                $scope.regions = regions;
              });

              // $scope.regions.fetch({ url: '/countries/' + countryIso3 + '/regions', reset: true });
            }
          });

          $scope.industries = [];
          promise = modelize('/industries').all();
          loadingTracker.addPromise(promise);

          promise.then(function (industries) {
            $scope.industries = industries;
          });

          $scope.showSuccessDialog = function () {
            return notificationDialog.show({
              title: 'Your application has been successfully submitted',
              text: 'You\'ve provided all the necessary information for your company to be reviewed. ' +
                    'Please wait for the ITU staff to approve your application.',
            });
          };

          $scope.updateProfile = function () {
            // Special check for logo existence (edge case)
            if (!$scope.model.logoUrl) return;

            return $scope.model.save().then(function () {
              if ($scope.model.isActive()) {
                humanizedMsg.displayMsg('Profile successfully updated');
                company.set($scope.model);

                $scope._form.disableUnloadConfirmation();
                $state.go('company.dashboard');
              } else if (!$scope.model.isJustCreated()) {
                company.set($scope.model);
                $scope.showSuccessDialog();

                // Sign-up, all other cases
                $scope._form.disableUnloadConfirmation();
                $state.go('company.sign-up');
              }

              // In any other case its still
              // in 'created' status, so stay on the form
            });
          };

          $scope.cancelForm = function () {
            $scope._form.disableUnloadConfirmation();
            $state.go('company.dashboard');
          };

          $scope.isFormLoading = function () {
            return $scope.model.$loading;
          };

          $scope.areReferencesLoading = function () {
            return loadingTracker.active();
          };


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
              url: $scope.model.resourceUrl() + '/logo',
              file: $scope.selectedFile
            })
            .success(function (data, status, headers, config) {
              $scope.fileUploaded = true;
              $scope.model.logoUrl = data.logoUrl;
            })
            .progress(function (e) {
              $scope.uploadProgress = parseInt(100.0 * e.loaded / e.total);
            })
            .finally(function () {
              $scope.isFileUploading = false;
              $scope.selectedFile = null;
            });
          };

          $scope.clearLogo = function () {
            $scope.model.clearLogo();
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
