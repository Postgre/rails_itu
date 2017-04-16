// A set for date/time/year/month picker directives for AngularJS

'use strict';

;(function (root, factory) {

  if (typeof define === 'function' && define.amd) {
    define(['angular', 'moment'], function (angular, moment) {
      return factory(angular, moment, document);
    });
  } else {
    factory(root.angular, root.moment, document);
  }

}(window, function (angular, moment, document, undefined) {
  return angular.module('ngExDatepickers', [])

    // DOESN'T WORK! DO NOT USE UNTIL FIXED!
    .directive('ngExYearPicker', ['$parse', '$timeout', function ($parse, $timeout) {
      return {
        restrict: 'EA',
        require: '^ngModel',
        scope: {
          model: '=ngModel',
          fieldName: '@name',
          required: '@required',
          disabled: '@disabled'
        },
        templateUrl: 'common/components/templates/datepickers/year-picker.html',

        link: function (scope, el, attrs, ngModelCtrl) {
          if (!ngModelCtrl) return;

          ngModelCtrl.$formatters.push(function (modelValue) {
            var year = parseInt(modelValue);
            if (isNaN(year)) return '';

            return new Date(year, 0, 1);
          });

          ngModelCtrl.$parsers.unshift(function (viewValue) {
            if (!viewValue) return '';
            if (angular.isDate(viewValue)) return viewValue.getFullYear();

            var parsedDate = angular.isString(viewValue) ? Date.parse(viewValue) : '';
            if (isNaN(parsedDate)) return '';

            return new Date(parsedDate).getFullYear();
          });

          scope.$watch('yearDate', function (val) {
            ngModelCtrl.$setViewValue(val);
          });

          ngModelCtrl.$render = function () {
            scope.yearDate = ngModelCtrl.$viewValue;
          };


          var options = attrs.pickerOptions ? $parse(attrs.pickerOptions)(scope) : {};
          scope.format = 'yyyy';
          options.outputFormat = options.outputFormat || options.format || 'yyyy';
          options.firstDay = options.firstDay || 1;

          scope.yearDate = new Date();
        }
      };
    }])

    .directive('ngExYearMonthSelect', ['$parse', function ($parse) {
      return {
        restrict: 'EA',
        require: '?ngModel',
        scope: {
          fieldName: '@name',
          required: '@required',
          disabled: '@disabled',
          minDate: '=',
          maxDate: '='
        },
        templateUrl: 'common/components/templates/datepickers/year-month-select.html',

        link: function (scope, el, attrs, ngModelCtrl) {
          if (!ngModelCtrl) return;

          ngModelCtrl.$formatters.push(function (modelValue) {
            // Expecting the variant of ISO-8601 Date string starting with '2010-05'
            if (!modelValue || !angular.isString(modelValue)) return { year: '', month: '' };

            return {
              year: modelValue.substr(0, 4),
              month: modelValue.substr(5, 2)
            };
          });

          ngModelCtrl.$parsers.unshift(function (viewValue) {
            if (!viewValue || !viewValue.year || !viewValue.month) return '';
            return viewValue.year + '-' + viewValue.month + '-01';
          });

          scope.$watchGroup(['year', 'month'], function (val) {
            ngModelCtrl.$setViewValue({ year: val[0], month: val[1] });

            var _datepickerForm = scope._datepickerForm;
            if (_datepickerForm) {
              var touched = _datepickerForm.year && _datepickerForm.year.$touched &&
                            _datepickerForm.month && _datepickerForm.month.$touched;

              if (touched && !ngModelCtrl.$touched) ngModelCtrl.$setTouched();
              else if (!touched && ngModelCtrl.$touched) ngModelCtrl.$setUntouched();
            }
          });

          scope.$watch('disabled', function (isDisabled) {
            if (isDisabled) {
              scope.month = '';
              scope.year = '';
            }
          });

          ngModelCtrl.$isEmpty = function (value) {
            return !value || !value.year || !value.month;
          };

          ngModelCtrl.$render = function () {
            scope.year  = ngModelCtrl.$viewValue.year;
            scope.month = ngModelCtrl.$viewValue.month;
          };


          // List generation helpers
          function generateYearList (minYear, maxYear) {
            var currentYear = (new Date()).getFullYear();
            minYear = minYear ? parseInt(minYear) : currentYear - 30;
            maxYear = maxYear ? parseInt(maxYear) : currentYear;

            scope.years = [];
            for (var i = minYear; i <= maxYear; i++) {
              scope.years.push(i.toString());
            }
          }

          function generateMonthList (minMonth, maxMonth) {
            var months = [
              { value: '01', name: 'January' },
              { value: '02', name: 'February' },
              { value: '03', name: 'March' },
              { value: '04', name: 'April' },
              { value: '05', name: 'May' },
              { value: '06', name: 'June' },
              { value: '07', name: 'July' },
              { value: '08', name: 'August' },
              { value: '09', name: 'September' },
              { value: '10', name: 'October' },
              { value: '11', name: 'November' },
              { value: '12', name: 'December' }
            ];

            if (minMonth) minMonth = parseInt(minMonth);
            if (maxMonth) maxMonth = parseInt(maxMonth);

            if (!minMonth || isNaN(minMonth) || minMonth < 1) minMonth = 1;
            if (!maxMonth || isNaN(maxMonth) || maxMonth > 12) maxMonth = 12;

            // Assuming 'months' is correctly ordered (we're sure now since they're hardcoded)
            scope.months = months.slice(minMonth - 1, maxMonth);
          }

          function generateDateLists (minDate, maxDate, currentYear) {
            var maxDateYear, maxDateMonth, minDateYear, minDateMonth, minMonth, maxMonth, _yearMonth;

            // Assumed format is short ISO-8601: 'YYYY-MM'
            // Should be changed when/if refactored to using dates

            if (minDate) {
              _yearMonth = minDate.split('-');
              minDateYear = _yearMonth[0];
              minDateMonth = _yearMonth[1];
            }

            if (maxDate) {
              _yearMonth = maxDate.split('-');
              maxDateYear = _yearMonth[0];
              maxDateMonth = _yearMonth[1];
            }

            if (maxDateYear && maxDateYear === currentYear) {
              maxMonth = maxDateMonth;
            }

            if (minDateYear && minDateYear === currentYear) {
              minMonth = minDateMonth;
            }

            generateMonthList(minMonth, maxMonth);
            generateYearList(minDateYear, maxDateYear);
          }

          generateDateLists(scope.minDate, scope.maxDate, scope.year);

          scope.$watchGroup(['minDate', 'maxDate', 'year'], function (dates) {
            generateDateLists(dates[0], dates[1], dates[2]);
          });
        }
      };
    }])

    .directive('ngExYearSelect', ['$parse', function ($parse) {
      return {
        restrict: 'EA',
        require: '?ngModel',
        scope: {
          fieldName: '@name',
          required: '@required',
          disabled: '@disabled',
          minYear: '=',
          maxYear: '='
        },
        templateUrl: 'common/components/templates/datepickers/year-select.html',

        link: function (scope, el, attrs, ngModelCtrl) {
          if (!ngModelCtrl) return;

          ngModelCtrl.$formatters.push(function (modelValue) {
            if (angular.isString(modelValue)) return modelValue;
            return modelValue ? modelValue.toString() : '';
          });

          ngModelCtrl.$parsers.unshift(function (viewValue) {
            if (angular.isString(viewValue)) {
              var parsed = parseInt(viewValue);
              if (!isNaN(parsed)) return parsed;
            }

            return null;
          });

          ngModelCtrl.$render = function () {
            scope.year = ngModelCtrl.$viewValue;
          };

          scope.$watch('year', function (year, oldYear) {
            if (year !== oldYear) ngModelCtrl.$setViewValue(year);
          });

          scope.$watch('disabled', function (isDisabled) {
            if (isDisabled) {
              scope.year = '';
            }
          });


          // Generate years list
          scope.$watchGroup(['minYear', 'maxYear'], function(newValues) {
            var currentYear = (new Date()).getFullYear(),
                minYear = scope.minYear,
                maxYear = scope.maxYear;

            if(!scope.minYear) minYear = currentYear - 30;
            if(!scope.maxYear) maxYear = currentYear;

            scope.years = [];
            for (var i = minYear; i <= maxYear; i++) {
              scope.years.push(i.toString());
            }
          });
        }
      };
    }]);

}));
