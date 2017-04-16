'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('company.sign-up', {

      url: '/sign-up/progress',
      templateUrl: appSettings.appPaths.features + '/company/sign-up/templates/progress.html',

      breadcrumb: {
        label: 'Sign-up progress'
      },

      resolve: {
        company: ['modelize', '$state', 'company', 'companyId', function (modelize, $state, company, companyId) {
          if (company.isActive()) {
            $state.go('company.dashboard', { companyId: companyId });
            return $q.reject();
          }

          return company;
        }]
      },

      controller: ['$scope', '$state', 'company', 'humanizedMsg',
        function ($scope, $state, company, humanizedMsg) {
          $scope.company = company;

          $scope.isStepCurrent = function (step) {
            return (step === 2 && company.isJustCreated()) || 
                   (step === 3 && company.isPending()) ||
                   (step === 4 && company.isActive()) || false;
          };

          $scope.isStepCompleted = function (step) {
            return step === 1 ||
                  (step === 2 && (company.isPending() || company.isActive())) ||
                  (step === 3 && (company.isActive())) || false;
          };

          $scope.isCompanyRejected = function () {
            // TODO: implement when time for this feature comes
            return false;
          };
        }]

    });

  }]);
