'use strict';

angular.module('bridge')

  .directive('roleSelectMenu', ['currentUser', '$window', '$state', '$rootScope', function (currentUser, $window, $state, $rootScope) {

    return {
      restrict: 'EA',
      templateUrl: 'app/features/shared/role-select-menu/templates/_role-select-menu.html',
      scope: {
      },

      link: function (scope, el, attrs) {
        scope.currentUser = currentUser;
        scope.userRoles = currentUser.roles;

        var stateParams = $rootScope.$stateParams;

        currentUser.getRoles();

        // Checks where we are to display correct menu item selected

        scope.isCandidateCurrently = function () {
          return $state.includes('candidate');
        };

        scope.isCompanyRepCurrently = function (companyId) {
          if (!companyId) return $state.includes('company');

          var stateCompanyId = stateParams && parseInt(stateParams.companyId);

          return $state.includes('company') && stateCompanyId === companyId;
        };

        scope.getCurrentCompanyName = function () {

          // Note: Not sure why companyId is string in stateParams, pretty odd
          var companyId = parseInt(stateParams.companyId);
          var role = _.find(scope.userRoles, { name: 'representative', resourceId: companyId });

          if (!role) return 'Unknown company';
          return role.resourceName;
        };

        scope.currentCompany = function () {

          // Note: Not sure why companyId is string in stateParams, pretty odd
          var companyId = parseInt(stateParams.companyId);
          var role = _.find(scope.userRoles, { name: 'representative', resourceId: companyId });

          if (!role) return 'Unknown company';
          return role;
        };


        scope.isStaffCurrently = function () {
          return $state.includes('staff');
        };

        // External navigation (hopefully, temp)
        scope.goToStaffApp = function () {
          $window.location.replace('/staff/dashboard');
        };
      }
    };
  }]);
