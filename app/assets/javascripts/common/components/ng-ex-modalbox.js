// ex-modalbox: modalbox component for AngularJS
// Somewhat based on Angular UI Bootstrap Modal concept but is different in that:
// - Not tied to Twitter Bootstrap
// - Doesn't use onTransitionEnd event and uses ngAnimate animations instead
// - Can be used in multiple containers
// - Loading indicators while data is being resolved / templates being loaded

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

  // Modalbox-specific stack-like data structure (similar to $$stackMap service from angular-ui.bootstrap)
  var ModalboxStack = function () {
    this.modalboxes = [];
    this.backdrops  = [];
  };

  angular.extend(ModalboxStack.prototype, {
    constructor: ModalboxStack,

    getAll: function () {
      return this.modalboxes;
    },

    get: function (instance) {
      for (var i = 0; i < this.modalboxes.length; i++) {
        if (instance === this.modalboxes[i].instance) {
          return this.modalboxes[i];
        }
      }
    },

    getByContainer: function ($containerEl) {
      var result = [];

      this.modalboxes.forEach(function (modalbox) {
        if (modalbox.$containerEl && $containerEl[0] === modalbox.$containerEl[0]) {
          result.push(modalbox);
        }
      });

      return result;
    },

    count: function ($containerEl) {
      if (!$containerEl) return this.modalboxes.length;
      if (!$containerEl.length) return 0;

      var count = 0;
      this.modalboxes.forEach(function (modalbox) {
        if (modalbox.$containerEl && $containerEl[0] === modalbox.$containerEl[0]) count++;
      });

      return count;
    },

    top: function ($containerEl) {
      if ($containerEl) {
        var containedModalboxes = this.getByContainer($containerEl);
        return containedModalboxes[containedModalboxes.length - 1];
      }

      return this.modalboxes[this.modalboxes.length - 1];
    },

    add: function (modalbox) {
      this.modalboxes.push(modalbox);
    },

    remove: function (instance) {
      for (var i = 0; i < this.modalboxes.length; i++) {
        if (instance === this.modalboxes[i].instance) {
          return this.modalboxes.splice(i, 1)[0];
        }
      }
    },

    removeTop: function () {
      return this.modalboxes.length ? this.modalboxes.splice(this.modalboxes.length - 1, 1) : undefined;
    },

    // Backdrop-related methods

    addBackdrop: function (backdrop) {
      this.backdrops.push(backdrop);
    },

    removeBackdrop: function ($backdropEl) {
      for (var i = 0; i < this.backdrops.length; i++) {
        if (this.backdrops[i].$el[0] === $backdropEl[0]) {
          return this.backdrops.splice(i, 1)[0];
        }
      }
    },

    getBackdropByContainer: function ($containerEl) {
      for (var i = 0; i < this.backdrops.length; i++) {
        if (this.backdrops[i].$containerEl[0] === $containerEl[0]) return this.backdrops[i];
      }
    },

    isBackdropNeededFor: function ($containerEl) {
      for (var i = 0; i < this.modalboxes.length; i++) {
        if (this.modalboxes[i].backdrop &&
            this.modalboxes[i].$containerEl &&
            $containerEl[0] === this.modalboxes[i].$containerEl[0]) return true;
      }

      return false;
    },

    getTopBackdropLayerIndex: function ($containerEl) {
      var topIndex = -1;

      var _modalboxes = ($containerEl && $containerEl.length) ? 
                        this.getByContainer($containerEl) :
                        this.getAll();

      _modalboxes.forEach(function (mb, i) {
        if (mb.backdrop) topIndex = i;
      });

      return topIndex;
    }
  });

  angular.module('ngExModalbox', [])

    .provider('modalbox', function () {
      
      // CSS class should hide container scrollbars and force new stacking context
      var modalboxContainerClass = this.modalboxContainerClass = 'modalbox-open modal-open';

      var defaults = this.defaults = {
        modalboxCssClass:   '',
        backdropCssClass:   '',
        container:          'body',
        keyboard:           true,
        backdrop:           true,
        loadingIndicator:   true,
        template:           false,
        templateUrl:        false,
        layoutTemplate:     false,
        layoutTemplateUrl:  false,
        remote:             false,
        remoteContent:      '',
        resolve:            {}
      };

      this.$get = ['$injector', '$document', '$rootScope', '$compile', '$q', '$http', '$templateCache', '$animate', '$controller', '$timeout',
        function ($injector, $document, $rootScope, $compile, $q, $http, $templateCache, $animate, $controller, $timeout) {

          var modalboxStack   = new ModalboxStack(),
              modalboxService = {};

          // Internal helper functions

          function isResolvable (value) {
            return angular.isFunction(value) || angular.isArray(value);
          }

          function anyResolvables (options) {
            var resolvables = 0;

            // TODO: Maybe combine with getAllPromises(...) somehow?
            if (options.resolve) {
              angular.forEach(options.resolve, function (value, key) {
                if (isResolvable(value)) resolvables++;
              });
            }

            return (!options.template && !$templateCache.get(options.templateUrl)) || resolvables > 0;
          }

          function getTemplatePromise (options) {
            return options.template ?
              $q.when(options.template) :
              $http.get(options.templateUrl, { cache: $templateCache }).then(function (result) {
                return result.data;
              });
          }

          function getRemoteContentPromise (options) {
            return options.remote ?
              $http.get(options.remote).then(function (result) {
                return result.data;
              }) : $q.when(false);
          }

          function getAllPromises (options) {
            var promises = [];

            // Content template and/or remote promises
            promises.push(options.remote ? getRemoteContentPromise(options) : getTemplatePromise(options));

            // Custom resolve promises
            if (options.resolve) {
              angular.forEach(options.resolve, function (value, key) {
                promises.push($q.when(isResolvable(value) ? $injector.invoke(value) : value));
              });
            }

            return promises;
          }

          // DOM manipulation helper

          var domUtil = {

            getContainerEl: function (options) {
              return angular.element(document.querySelector(options.container));
            },

            createBackdropEl: function (options) {
              return angular.element('<div modalbox-backdrop class="modalbox-backdrop modalbox-backdrop-animate modal-backdrop"></div>');
            },

            createLoadingIndicatorEl: function (options) {
              var indicatorEl = angular.element('<div class="modalbox-loading-indicator modalbox-loading-indicator-animate"><div class="modalbox-loading-icon"><div class="icon fa fa-refresh fa-spin"></div></div></div>');
              indicatorEl.css('z-index', 1045 + options.layerIndex * 10);

              if (!options.backdrop) indicatorEl.addClass('no-backdrop');

              return indicatorEl;
            },

            createModalboxEl: function (modalboxInstance, options, scope, $containerEl) {
              var rawModalboxEl = angular.element('<div tabindex="-1" modalbox class="modalbox modalbox-animate modal open"></div>');
              rawModalboxEl.data('modalboxInstance', modalboxInstance);

              var modalboxEl = $compile(rawModalboxEl)(scope);

              // Note: CSS-class assigned to containerEl is assumed to create new stacking context
              // TODO: Move this 1050 value to options or either read CSS rules
              modalboxEl.css('z-index', 1050 + options.layerIndex * 10);

              return modalboxEl;
            },

            append: function ($el, $containerEl, callback) {
              var promise = $animate.enter($el, $containerEl, callback);
              if (promise && promise.then) promise.then(callback);

              return promise;
            },

            remove: function ($el, callback) {
              var promise = $animate.leave($el, callback);
              if (promise && promise.then) promise.then(callback);

              return promise;
            },

            updateBackdropZIndex: function (backdrop) {
              // TODO: Move 1040 value to options or either read CSS rules
              backdrop.$el.css('z-index', 1040 + (backdrop.layerIndex && 1 || 0) + backdrop.layerIndex * 10);
            }

          };

          // ESC key support
          $document.bind('keydown', function (e) {
            if (e.which === 27) {
              var modalbox = modalboxStack.top();

              if (modalbox && modalbox.keyboard) {
                $rootScope.$apply(function () {
                  modalboxService.dismiss(modalbox.instance);
                });
              }
            }
          });


          // Modalbox (instance) class
          var Modalbox = function (options) {
            this.result = options.resultPromise;
            this.opened = options.openedPromise;
          };

          angular.extend(Modalbox.prototype, {
            constructor: Modalbox,

            close: function (result) {
              modalboxService.close(this, result);
            },

            dismiss: function (reason) {
              modalboxService.dismiss(this, reason);
            }
          });

          // Modalbox internal methods
          
          function initBackdrop (options, containerEl, prevModalbox) {
            if (!options.backdrop) return;

            var backdrop = modalboxStack.getBackdropByContainer(containerEl);

            if (!backdrop) {
              backdrop = {
                $el: domUtil.createBackdropEl(options),
                $containerEl: containerEl,
                layerIndex: -1,
                cssClasses: []
              };

              modalboxStack.addBackdrop(backdrop);
              domUtil.append(backdrop.$el, containerEl);
            }

            // Set backdrop layer index, assuming we're initializing backdrop
            // ONLY after new modalbox is added to stack and is taken into account
            // by modalboxStack for layer index resolution
            backdrop.layerIndex = modalboxStack.getTopBackdropLayerIndex(containerEl);
            domUtil.updateBackdropZIndex(backdrop);

            // Note: We've already added the current modalbox to stack
            // so what we need isn't the last one but one before it
            // prevModalbox && prevModalbox.backdropCssClass && backdrop.$el.removeClass(prevModalbox.backdropCssClass);
            // options.backdropCssClass && backdrop.$el.addClass(options.backdropCssClass);
            
            // Swap backdrop CSS classes from "current to previous" modalbox
            // Note: since we got a stack, everything is assumed to be in right order
            if (backdrop.cssClasses.length)
              backdrop.$el.removeClass(backdrop.cssClasses[backdrop.cssClasses.length - 1]);

            if (options.backdropCssClass) {
              backdrop.$el.addClass(options.backdropCssClass);
              backdrop.cssClasses.push(options.backdropCssClass);
            }

            return backdrop;
          }

          function tryInitLoadingIndicator (modalbox, options) {
            if (!anyResolvables(options)) return;

            var loadingIndicatorEl = domUtil.createLoadingIndicatorEl(options);
            domUtil.append(loadingIndicatorEl, modalbox.$containerEl);

            options.openedPromise.finally(function () {
              domUtil.remove(loadingIndicatorEl, function () {
                loadingIndicatorEl = undefined;
              });
            });
          }
          
          function openModalbox (options) {
            options = angular.extend({}, defaults, options);

            if (!options.template && !options.templateUrl && !options.remote) {
              throw new Error('Modalbox needs either "template", "templateUrl" or "remote" property defined.');
            }
        
            var resultDeferred   = $q.defer(),
                openedDeferred   = $q.defer(),
                containerEl      = domUtil.getContainerEl(options);

            options.layerIndex = modalboxStack.count(containerEl);
            options.resultPromise = resultDeferred.promise;
            options.openedPromise = openedDeferred.promise;

            var modalboxInstance = new Modalbox(options);

            // Modalbox main object to be stored onto the stack
            var modalbox = angular.extend({}, options, {
              instance: modalboxInstance,
              $containerEl: containerEl,
              scope: false,
              resultDeferred: resultDeferred
            });

            
            // Get previous modalbox from stack (will need that later to swap backdrop classes)
            var prevModalbox = modalboxStack.top(containerEl);

            // Add to stack right away (thus our stacking is in correct order)
            modalboxStack.add(modalbox);

            // Note: It is important that initBackdrop() is called
            // after new modalbox is added to the stack
            if (options.loadingIndicator) {
              initBackdrop(options, containerEl, prevModalbox);
              containerEl.addClass(modalboxContainerClass);

              tryInitLoadingIndicator(modalbox, options);
            }

            $q.all(getAllPromises(options)).then(function (resolved) {
              // Note: resolved[0] is either remote content or resolved template
              options.template = resolved.shift();
              if (options.remote) options.remoteContent = options.template;

              if (!options.loadingIndicator) {
                initBackdrop(options, containerEl, prevModalbox);
                containerEl.addClass(modalboxContainerClass);
              }

              onModalboxResolved(modalbox, options, resolved);

              openedDeferred.resolve(true);
            }, function (reason) {
              openedDeferred.reject(false);
              resultDeferred.reject(reason);

              destroyModalbox(modalbox);
            });

            return modalbox.instance;
          }
          
          function onModalboxResolved (modalbox, options, resolvedArray) {
            // Scope
            var modalboxScope = (options.scope || $rootScope).$new();
            modalboxScope.$closeModalbox   = modalbox.instance.close.bind(modalbox.instance);
            modalboxScope.$dismissModalbox = modalbox.instance.dismiss.bind(modalbox.instance);

            // In case controller is specified - initialize it
            if (options.controller) {
              var ctrlLocals = {
                $scope: modalboxScope,
                modalboxInstance: modalbox.instance
              };

              var i = 0;
              angular.forEach(options.resolve, function (value, key) {
                ctrlLocals[key] = resolvedArray[i++];
              });

              $controller(options.controller, ctrlLocals);
            }


            modalbox.$el = domUtil.createModalboxEl(modalbox.instance, options, modalboxScope, modalbox.$containerEl);
            
            if (options.remote) {
              // We don't need to compile remote content
              modalbox.$el.append(options.remoteContent);
            } else {
              // We got template to compile
              modalbox.$el.append($compile(angular.element(options.template))(modalboxScope));
            }

            // Append to container finally
            domUtil.append(modalbox.$el, modalbox.$containerEl);

            modalbox.scope = modalboxScope;

            return modalbox;
          }

          function destroyModalbox (modalbox) {
            modalboxStack.remove(modalbox.instance);

            if (modalbox.scope) modalbox.scope.$destroy();

            var noModalboxesDeferred      = $q.defer(),
                containerCssClassPromise  = noModalboxesDeferred.promise,
                backdropCssClass          = modalbox.backdropCssClass,
                $containerEl              = modalbox.$containerEl;

            if (modalbox.$el) {
              domUtil.remove(modalbox.$el, function () {
                modalbox.$el = null;
                modalbox = null;
                if (!modalboxStack.count($containerEl)) {
                  noModalboxesDeferred.resolve();
                } else {
                  noModalboxesDeferred.reject();
                }
              });
            }

            if (modalbox.backdrop) {
              var backdrop = modalboxStack.getBackdropByContainer($containerEl);

              if (backdrop && backdrop.$el.length) {

                // Remove backdrop if not needed anymore
                if (!modalboxStack.isBackdropNeededFor($containerEl)) {

                  modalboxStack.removeBackdrop(backdrop.$el);

                  var backdropDestroyedDeferred = $q.defer();
                  containerCssClassPromise = $q.all([noModalboxesDeferred.promise, backdropDestroyedDeferred.promise]);

                  domUtil.remove(backdrop.$el, function () {
                    backdropDestroyedDeferred.resolve();
                    backdrop.$el = null;
                    backdrop = undefined;
                  });

                } else {
                  backdrop.layerIndex = modalboxStack.getTopBackdropLayerIndex(backdrop.$containerEl);
                  domUtil.updateBackdropZIndex(backdrop);

                  // Swap backdrop CSS classes from "current to previous" modalbox
                  if (backdropCssClass)
                    backdrop.$el.removeClass(backdrop.cssClasses.pop());

                  if (backdrop.cssClasses.length)
                    backdrop.$el.addClass(backdrop.cssClasses[backdrop.cssClasses.length - 1]);
                }
              }
            }

            containerCssClassPromise.then(function () {
              $containerEl.removeClass(modalboxContainerClass);

              // Force reflow
              /*jshint -W030 */
              $containerEl[0].offsetWidth;
            });

            // modalbox = undefined;
          }

          // Modalbox public methods

          angular.extend(modalboxService, {

            open: function (options) {
              return openModalbox(options);
            },

            remote: function (url, options) {
              
            },

            load: function (url, options) {
              
            },

            loadState: function (stateName, options) {
              
            },

            close: function (modalboxInstance, result) {
              var modalbox = modalboxStack.get(modalboxInstance);
              if (modalbox) {
                modalbox.resultDeferred.resolve(result);
                destroyModalbox(modalbox);
              }
            },

            dismiss: function (modalboxInstance, reason) {
              var modalbox = modalboxStack.get(modalboxInstance);
              if (modalbox) {
                modalbox.resultDeferred.reject(reason);
                destroyModalbox(modalbox);
              }
            },

            dismissAll: function (reason) {
              var topModalbox = modalboxStack.top();
              while (topModalbox) {
                this.dismiss(topModalbox.instance, reason);
                topModalbox = modalboxStack.top();
              }
            },

            get: function (modalboxInstance) {
              return modalboxStack.get(modalboxInstance);
            },

            getTop: function () {
              return modalboxStack.top();
            }
          });

          return modalboxService;
        }];

    })

    .directive('modalbox', ['modalbox', '$timeout', function (modalbox, $timeout) {
      return {
        restrict: 'EA',
        replace: true,
        transclude: true,
        scope: { },
        template: '<div ng-click="close($event)" ng-transclude></div>',
        link: function (scope, el, attrs) {
          $timeout(function () {
            el[0].focus();
          });

          var modalboxInstance = el.data('modalboxInstance');
          if (!modalboxInstance) return;


          scope.close = function (e) {
            if (e.target !== e.currentTarget) return;

            var mb = modalbox.get(modalboxInstance);
            if (mb && mb.backdrop && mb.backdrop !== 'static') {
              e.preventDefault();
              e.stopPropagation();
              modalboxInstance.dismiss();
            }
          };
        }
      };
    }]);

}));
