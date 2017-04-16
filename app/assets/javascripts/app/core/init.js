'use strict';

// Core initialization tasks

// Attach $state and $stateParams services to $rootScope so it is globally available
angular.module('bridge').run(['$rootScope', '$state', '$stateParams', function ($rootScope, $state, $stateParams) {
  $rootScope.$state = $state;
  $rootScope.$stateParams = $stateParams;
}]);

// Make UI-Router use default $anchorScroll to scroll to top when view changes by default
angular.module('bridge').config(['$uiViewScrollProvider', function ($uiViewScrollProvider) {
  $uiViewScrollProvider.useAnchorScroll();
}]);

// Make current user globally available
// FIXME: it's really BAD from architectural side. We need to build menu controller in ui-router for that.
angular.module('bridge').run(['$rootScope', 'currentUser', 'accountService', function ($rootScope, currentUser, accountService) {
  $rootScope.currentUser = currentUser;
  $rootScope.accountService = accountService;
}]);

// Make config.logoutUrl globally available
angular.module('bridge').run(['$rootScope', 'appSettings', 'idUrl', function ($rootScope, appSettings, idUrl) {
  $rootScope.logoutUrl = idUrl + '/sign-out' || '';
}]);
