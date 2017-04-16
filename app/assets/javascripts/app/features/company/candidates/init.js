'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.candidates', {
        abstract: true,
        url: '/candidates',
        template: appSettings.passthroughTemplate,
        breadcrumb: {
          label: 'Candidates',
          stateRef: 'company.candidates.list.search'
        },

        resolve: {
          // Re-resolve check
          company: ['$state', '$q', 'company', function ($state, $q, company) {
            if (!company.isActive()) {
              $state.go('company.sign-up', { companyId: company.id });
              return $q.reject();
            }

            return company;
          }]
        }

      });

  }]);

