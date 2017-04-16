'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.companies.details', {

      url: '/:companyId',
      templateUrl: appSettings.appPaths.features + '/candidate/companies/templates/details.html',

      resolve: {
        company: ['$stateParams', 'modelize', function ($stateParams, modelize) {
          return modelize.one('companies', parseInt($stateParams.companyId)).get().$future;
        }]
      },

      controller: ['$scope', 'company', function ($scope, company) {
        $scope.company = company;
      }]

    });

  }]);
