// Humanized message component for AngularJS

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

  return angular.module('ngExHumanizedMsg', [])

    .provider('humanizedMsg', function () {

      var defaults = this.defaults = {
        cssClass:    'humanized-msg--default',
        container:   'body',
        duration:    3000,
        keyboard:    true,
        hideOnHover: true
      };

      this.$get = ['$document', '$rootScope', '$compile', '$q', '$animate', '$timeout',
        function ($document, $rootScope, $compile, $q, $animate, $timeout) {

          var humanMsgService = {};

          // DOM manipulation helper

          var domUtil = {

            getContainerEl: function (options) {
              return angular.element(document.querySelector(options.container));
            },

            createMsgEl: function (humanMsgInstance, message, options) {
              var rawEl = angular.element('<div tabindex="-1" humanized-msg class="humanized-msg humanized-msg-animate">' + message + '</div>');
              rawEl.data('humanMsgInstance', humanMsgInstance);

              var el = $compile(rawEl)(humanMsgInstance.scope);

              // Note: CSS-class assigned to containerEl is assumed to create new stacking context
              // TODO: Move this 9050 value to options or either read CSS rules
              el.css('z-index', 9050);

              return el;
            },

            append: function ($el, $containerEl, doneCallback) {
              $animate.enter($el, $containerEl, angular.element($containerEl[0].lastChild), doneCallback);
            },

            remove: function ($el, doneCallback) {
              $animate.leave($el, doneCallback);
            }

          };

          // ESC key support
          // TODO: Implement stack
          // $document.bind('keydown', function (e) {
          //   if (e.which === 27) {
          //     var humanMsg = humanMsgStack.top();

          //     if (humanMsg && humanMsg.keyboard) {
          //       $rootScope.$apply(function () {
          //         humanMsgService.destroy(humanMsg.instance);
          //       });
          //     }
          //   }
          // });


          // Humanized Message class
          var HumanizedMsg = function (options) {
            angular.extend(this, options);
          };

          angular.extend(HumanizedMsg.prototype, {
            constructor: HumanizedMsg,

            hide: function () {
              humanMsgService.destroy(this);
            }
          });

          // Internal/private methods

          function displayMsg (message, options) {
            options = angular.extend({}, defaults, options);
        
            var humanMsgInstance = new HumanizedMsg(options),
            containerEl          = domUtil.getContainerEl(options);

            humanMsgInstance.message = message;
            humanMsgInstance.scope = $rootScope.$new();
            humanMsgInstance.$el = domUtil.createMsgEl(humanMsgInstance, message, options);

            if (options.cssClass) {
              humanMsgInstance.$el.addClass(options.cssClass);
            }

            domUtil.append(humanMsgInstance.$el, containerEl);
            

            $timeout(function () {
              humanMsgInstance.hide();
            }, options.duration);

            return humanMsgInstance;
          }

          function destroyMsg (humanMsgInstance) {
            if (humanMsgInstance.scope) humanMsgInstance.scope.$destroy();
            if (humanMsgInstance.$el) domUtil.remove(humanMsgInstance.$el);

            humanMsgInstance = undefined;
          }

          // Public methods

          angular.extend(humanMsgService, {

            displayMsg: function (message, options) {
              return displayMsg(message, options);
            },

            destroy: function (humanMsgInstance) {
              return destroyMsg(humanMsgInstance);
            }

          });

          return humanMsgService;
        }];

    })

    .directive('humanizedMsg', ['$timeout', function ($timeout) {
      return {
        restrict: 'EA',
        replace: true,
        transclude: true,
        scope: { },
        template: '<div ng-mouseenter="hide($event)" ng-transclude></div>',
        link: function (scope, el, attrs) {
          var humanMsgInstance = el.data('humanMsgInstance');
          if (!humanMsgInstance) return;

          scope.hide = function (e) {
            if (!humanMsgInstance.hideOnHover) return;

            e.preventDefault();
            e.stopPropagation();
            humanMsgInstance.hide();
          };
        }
      };
    }]);

}));
