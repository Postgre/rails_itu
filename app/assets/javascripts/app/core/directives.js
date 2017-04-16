'use strict';

angular.module('bridge')

  .factory('coreTemplatesPath', ['appSettings', function (appSettings) {
    return appSettings.appPaths.core + '/templates';
  }])

  // Layout directives

  .directive('mainHeader', ['coreTemplatesPath', function (templateUrlsPrefix) {
    return {
      restrict: 'EA',
      replace: true,
      templateUrl: templateUrlsPrefix + '/main-header.html'
    };
  }])

  .directive('subHeader', ['coreTemplatesPath', function (templateUrlsPrefix) {
    return {
      restrict: 'EA',
      replace: true,
      transclude: true,
      templateUrl: templateUrlsPrefix + '/sub-header.html'
    };
  }])

  .directive('subHeaderBreadcrumbs', ['coreTemplatesPath', function (templateUrlsPrefix) {
    return {
      restrict: 'EA',
      templateUrl: templateUrlsPrefix + '/sub-header-breadcrumbs.html'
    };
  }])

  // TODO: DRY these

  .directive('navCandidate', ['coreTemplatesPath', function (templateUrlsPrefix) {
    return {
      restrict: 'EA',
      replace: true,
      templateUrl: templateUrlsPrefix + '/nav-candidate.html'
    };
  }])

  .directive('navCompany', ['coreTemplatesPath', '$state', function (templateUrlsPrefix, $state) {
    return {
      restrict: 'EA',
      scope: {
        company: '='
      },
      templateUrl: templateUrlsPrefix + '/nav-company.html',
      link: function (scope) {
        scope.$state = $state;
      }
    };
  }])

  .directive('navStaff', ['coreTemplatesPath', function (templateUrlsPrefix) {
    return {
      restrict: 'EA',
      replace: true,
      templateUrl: templateUrlsPrefix + '/nav-staff.html'
    };
  }])

  // Click fix directive
  
  .directive('preventClick', function () {
    return {
      restrict: 'A',
      priority: 100,
      link: function (scope, el, attrs) {
        el.on('click', function (e) {
          e.preventDefault();
        });
      }
    };
  })

  // Reusable input directives

  .directive('setFocus', ['$timeout', function ($timeout) {
    return function (scope, el, attrs) {
      scope.$watch(attrs.setFocus, function (expr) {
        if (expr) {
          $timeout(function () {
            el[0].focus();
            el[0].selectionStart = el[0].selectionEnd = el[0].value.length;
          }, 0, false);
        }
      });
    };
  }])

  .directive('setSelection', ['$timeout', function ($timeout) {
    return function (scope, el, attrs) {
      scope.$watch(attrs.setSelection, function (expr) {
        if (expr) {
          $timeout(function () {
            el[0].select();
          }, 0, false);
        }
      });
    };
  }]);
