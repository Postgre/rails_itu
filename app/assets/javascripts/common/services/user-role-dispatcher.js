'use strict';

angular.module('bridge')

  .factory('userRoleDispatcher', ['$state', '$window', '$rootScope', '$q', 'currentUser',
    function ($state, $window, $rootScope, $q, currentUser) {

      var dispatcher = {

        redirect: function (userRoleName, resourceId) {
          if(angular.isDefined($window.staticPage)) return;
          switch (userRoleName) {
            case 'staff':
              $window.location.replace('/staff/dashboard');
              break;
            case 'candidate':
              $state.go('candidate.resume.index');
              break;
            case 'representative':
              $state.go('company.dashboard', { companyId: resourceId });
              break;
            default:
              if (!$state.is('index')) $state.go('index');
          }
        },

        dispatch: function () {
          currentUser.getRoles().then(function (roles) {
            if (roles && roles.length) {
              dispatcher.redirect(roles[0].name, roles[0].resourceId);
            } else {
              // TODO:
              // Redirect to "no roles" error?
            }
          });
        }
      };

      return dispatcher;

    }]);
