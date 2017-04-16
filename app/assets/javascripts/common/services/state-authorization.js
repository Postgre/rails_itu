'use strict';

angular.module('bridge')

  .run(['$rootScope', '$state', '$stateParams', 'currentUser', 'stateChangeResolver', '$q',
    function ($rootScope, $state, $stateParams, currentUser, stateChangeResolver, $q) {

      stateChangeResolver.addHandler(function (e, toState, toStateParams, fromState, fromStateParams) {
        var allowRoles = toState && toState.data && toState.data.allowRoles;

        if (_.isArray(allowRoles) && allowRoles.length) {
          e.preventDefault();

          var stateChangeDeferred = $q.defer();

          currentUser.getRoles().then(function (roles) {
            var allowed = _.any(allowRoles, function (roleName) {
              if (roleName === 'representative') {
                // Note: Explicit parsing is needed because toStateParams are stringified
                var companyId = parseInt(toStateParams.companyId);
                return currentUser.isCompanyRep() && companyId && currentUser.isCompanyAllowed(companyId);
              }

              return currentUser.isInRole(roleName);
            });

            if (allowed) {
              stateChangeDeferred.resolve();
            } else {
              stateChangeDeferred.reject();
              $state.go('index');
            }
          });

          return stateChangeDeferred.promise;
        }
      });

  }]);
