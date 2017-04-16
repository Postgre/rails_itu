'use strict';

angular.module('bridge.staff', [
  'angular-loading-bar',
  'ncy-angular-breadcrumb',
  'bridge', // Anything common 'bridge' module contains
  'templates',
  'bridge.resources',
  'ui.select2'
]);

angular.module('bridge.staff').config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    return $locationProvider.hashPrefix('!');
  }
]);

angular.module('bridge.staff').config(['$stateProvider', '$urlRouterProvider', function ($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('/');

  $stateProvider
    .state('index', {
      url: '/',
      views: {
        'menu-view': {
          controller: 'TopMenuController',
          templateUrl: 'staff/common/staff-menu.html'},
        'content-view': {
          controller: 'ApplicationController',
          templateUrl: 'staff/common/default-layout.html'}
      },
      ncyBreadcrumb: {
        label: 'Home page'
      }
    })

    .state('candidates', {
      url: '/candidates',
      views: {
        'menu-view': {
          controller: 'TopMenuController',
          templateUrl: 'staff/common/staff-menu.html'},
        'content-view': {
          controller: 'CandidatesController',
          templateUrl: 'staff/candidates/candidates.html'}
      },
      ncyBreadcrumb: {
        label: 'Candidates'
      }
    })

    .state('candidates.detail', {
        url: '/:id',
        controller: 'CandidateController',
        templateUrl: 'staff/candidates/candidates.detail.html',
        ncyBreadcrumb: {
          label: '{{candidate.user.email}}',
          parent: 'users'
        }
    })

    .state('companies', {
      url: '/companies',
      views: {
        'menu-view': {
          controller: 'TopMenuController',
          templateUrl: 'staff/common/staff-menu.html'},
        'content-view': {
          controller: 'CompaniesController',
          templateUrl: 'staff/companies/companies.html'}
      },
      ncyBreadcrumb: {
        label: 'Companies'
      }
    })

    .state('companies.detail', {
        url: '/:id',
        controller: 'CompanyController',
        templateUrl: 'staff/companies/companies.detail.html',
        ncyBreadcrumb: {
          label: '{{company.name}}'
        }
    })


    .state('users', {
      url: '/users',
      views: {
        'menu-view': {
          controller: 'TopMenuController',
          templateUrl: 'staff/common/staff-menu.html'},
        'content-view': {
          controller: 'UsersController',
          templateUrl: 'staff/users/users.html'}
      },
      ncyBreadcrumb: {
        label: 'Users'
      }
    })

    .state('jobs', {
      url: '/jobs/{companyId}',
      views: {
        'menu-view': {
          controller: 'TopMenuController',
          templateUrl: 'staff/common/staff-menu.html'},
        'content-view': {
          controller: 'JobsController',
          templateUrl: 'staff/jobs/jobs.html'}
      },
      params: {
        companyId: {value: ''}
      },
      ncyBreadcrumb: {
        label: 'Jobs'
      }
    })

    .state('jobs.detail', {
      url: '/:id',
      controller: 'JobDetailController',
      templateUrl: 'staff/jobs/job.detail.html',
      ncyBreadcrumb: {
        label: '{{job.title}}'
      }
    })

    .state('jobs.detail.recommended', {
      url: '/recommended',
      controller: 'JobRecommendedController',
      templateUrl: 'staff/jobs/job.recommended.html',
      ncyBreadcrumb: {
        label: 'Recommended Candidates'
      }
    })

    .state('jobs.detail.applications', {
      url: '/applications',
      controller: 'JobApplicationsController',
      templateUrl: 'staff/jobs/job.applications.html',
      ncyBreadcrumb: {
        label: 'Applied Candidates'
      }
    })

    .state('skills', {
      url: '/skills',
      views: {
        'menu-view': {
          controller: 'TopMenuController',
          templateUrl: 'staff/common/staff-menu.html'},
        'content-view': {
          controller: 'SkillsController',
          templateUrl: 'staff/skills/skills.html'}
      }
    })

    .state('skills.detail', {
        url: '/:id',
        controller: 'SkillDetailController',
        templateUrl: 'staff/skills/skill.detail.html'
    })

  .state('staffinbox', {
    abstract: false,
    url: '/staffinbox',
      views: {
        'menu-view': {
          controller: 'TopMenuController',
          templateUrl: 'staff/common/staff-menu.html'},
        'content-view': {
          templateUrl: 'app/features/shared/inbox/list.html',
          controller: 'InboxController',
          controllerAs: 'inbox'
        }
      }
  });

}]);
