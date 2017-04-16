'use strict';

angular.module('bridge.resources', ['restangular']).config(['RestangularProvider', 'apiUrl', function (RestangularProvider, apiUrl) {
  RestangularProvider.setBaseUrl(apiUrl);
}]);

// Common 'bridge' module, included into both:
// - Client app (/app) bridge.app module
// - Website (/site) bridge.site module

angular.module('bridge', [
  'ngAnimate',
  'ngSanitize',
  'ngCookies',
  'ui.router',
  'mgcrea.ngStrap',
  'templates',
  'ngExPromiseTracker',
  'ngExModalbox',
  'ngExHumanizedMsg',
  'ngExTopslideErrorMsg',
  'angular-modelizer',
  'uiGmapgoogle-maps',
  'ngSanitize',
  'ang-drag-drop'
]);

angular.module('bridge')
.config(['$datepickerProvider', function($datepickerProvider) {
  angular.extend($datepickerProvider.defaults, {
    autoclose: true
  });
}]);

angular.module('bridge')
.config(['$timepickerProvider', function($timepickerProvider) {
  angular.extend($timepickerProvider.defaults, {
    autoclose: true
  });
}]);

angular.module('bridge')
.config(['$typeaheadProvider', function($typeaheadProvider) {
  angular.extend($typeaheadProvider.defaults, {
    minLength: 2
  });
}]);

angular.module('bridge')
.config(['uiGmapGoogleMapApiProvider', function(uiGmapGoogleMapApiProvider) {
    uiGmapGoogleMapApiProvider.configure({
        // key: '',
        v: '3.17',
        libraries: 'geometry,visualization'
    });
}]);
