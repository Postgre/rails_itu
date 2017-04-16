// Error message component for AngularJS

'use strict';

;(function (factory) {

  if (typeof define === 'function' && define.amd) {
    define(['angular'], function (angular) {
      return factory(angular, document);
    });
  } else {
    factory(angular, document);
  }

}(function (angular, document, undefined) {

  return angular.module('ngExTopslideErrorMsg', [])

    .provider('ngExTopslideErrorMsg', function () {

      var defaults = this.defaults = {
        cssClass:     '',
        iconCssClass: 'fa-exclamation-triangle',
        container:    'body',
        duration:     0,
        keyboard:     true,
        hideOnHover:  false
      };

      this.$get = ['$document', '$rootScope', '$compile', '$q', '$animate', '$timeout',
        function ($document, $rootScope, $compile, $q, $animate, $timeout) {

          var errorMsgService = {};

          // DOM manipulation helper

          var domUtil = {

            getContainerEl: function (options) {
              return angular.element(document.querySelector(options.container));
            },

            createMsgEl: function (errorMsgInstance, message, options) {
              var rawEl = angular.element('<div tabindex="-1" ng-ex-error-msg ' +
                                          'class="topslide-error-msg-block topslide-error-msg-animate">' + 
                                          '<i class="topslide-error-msg-icon fa ' + options.iconCssClass + '"></i> ' + 
                                          message + '</div>');
              rawEl.data('errorMsgInstance', errorMsgInstance);

              var el = $compile(rawEl)(errorMsgInstance.scope);

              return el;
            },

            append: function ($el, $containerEl, doneCallback) {
              $animate.enter($el, $containerEl, angular.element($containerEl[0].lastChild), doneCallback);
            },

            remove: function ($el, doneCallback) {
              $animate.leave($el, doneCallback);
            }

          };

          // Humanized Message class
          var TopslideErrorMsg = function (options) {
            angular.extend(this, options);
          };

          angular.extend(TopslideErrorMsg.prototype, {
            constructor: TopslideErrorMsg,

            hide: function () {
              errorMsgService.destroy(this);
            }
          });

          // Internal/private methods

          function showMsg (message, options) {
            options = angular.extend({}, defaults, options);

            // If no 'forever: true' option is passed and
            // 'duration' isn't set explicitly - make it default to 4s
            if (!options.duration && !options.forever) {
              options.duration = 4000;
            }
        
            var errorMsgInstance = new TopslideErrorMsg(options),
            containerEl          = domUtil.getContainerEl(options);

            errorMsgInstance.message = message;
            errorMsgInstance.scope = $rootScope.$new();
            errorMsgInstance.$el = domUtil.createMsgEl(errorMsgInstance, message, options);

            if (options.cssClass) {
              errorMsgInstance.$el.addClass(options.cssClass);
            }

            domUtil.append(errorMsgInstance.$el, containerEl);
            
            if (options.duration) {
              $timeout(function () {
                errorMsgInstance.hide();
              }, options.duration);
            }

            return errorMsgInstance;
          }

          function destroyMsg (errorMsgInstance) {
            if (errorMsgInstance.scope) errorMsgInstance.scope.$destroy();
            if (errorMsgInstance.$el) domUtil.remove(errorMsgInstance.$el);

            errorMsgInstance = undefined;
          }

          // Public methods

          angular.extend(errorMsgService, {

            show: function (message, options) {
              return showMsg(message, options);
            },

            destroy: function (errorMsgInstance) {
              return destroyMsg(errorMsgInstance);
            }

          });

          return errorMsgService;
        }];

    })

    .directive('ngExErrorMsg', ['$timeout', function ($timeout) {
      return {
        restrict: 'EA',
        transclude: true,
        scope: { },
        template: '<div class="topslide-error-msg">' +
                    '<span ng-transclude></span>' +
                    '<button ng-click="hide($event)" class="topslide-error-msg-close-icon"><i class="fa fa-times-circle"></i></button>' +
                  '</div>',
        link: function (scope, el, attrs) {
          var errorMsgInstance = el.data('errorMsgInstance');
          if (!errorMsgInstance) return;

          scope.hide = function (e) {
            e.preventDefault();
            e.stopPropagation();
            errorMsgInstance.hide();
          };
        }
      };
    }]);

}));
