'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company', {
        abstract: true,
        url: '/company/:companyId',
        templateUrl: appSettings.appPaths.features + '/company/templates/layout.html',

        data: {
          allowRoles: ['representative']
        },

        resolve: {
          companyId: ['$stateParams', function ($stateParams) {
            return ($stateParams && $stateParams.companyId && parseInt($stateParams.companyId)) || null;
          }],

          company: ['modelize', '$state', '$q', 'companyId', function (modelize, $state, $q, companyId) {
            return modelize.one('company', companyId).get();
          }]
        },

        breadcrumb: {
          label: 'Company',
          stateRef: 'company.dashboard'
        },

        controller: ['$scope', 'company', function ($scope, company) {
          $scope.company = company;
        }]
      })

      .state('company.profile', {
        abstract: true,
        url: '/profile',
        template: appSettings.passthroughTemplate,
        breadcrumb: {
          label: 'Profile',
          stateRef: 'company.dashboard'
        }
      });

  }]);
