'use strict';

angular.module('bridge')

  .config(['$timepickerProvider', '$datepickerProvider', function ($timepickerProvider, $datepickerProvider) {

    _.extend($timepickerProvider.defaults, {
      iconUp:   'fa fa-angle-up',
      iconDown: 'fa fa-angle-down',
    });

    _.extend($datepickerProvider.defaults, {
      iconLeft:  'fa fa-angle-left',
      iconRight: 'fa fa-angle-right',
    });

  }]);
