'use strict';

// Feature common/abstract states

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider

      .state('company.jobs', {
        abstract: true,
        url: '/jobs',
        template: appSettings.passthroughTemplate,
        breadcrumb: {
          label: 'Jobs',
          stateRef: 'company.jobs.list'
        },

        resolve: {
          // Re-resolve check
          company: ['$state', '$q', 'company', function ($state, $q, company) {
            if (!company.isActive()) {
              $state.go('company.sign-up', { companyId: company.id });
              return $q.reject();
            }

            return company;
          }],

          jobs: ['modelize', 'company', 'companyId', function (modelize, company, companyId) {
            return modelize.one('company', companyId).many('jobs').all().$future;
          }]
        }
      });

  }]);

