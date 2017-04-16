'use strict';

angular.module('bridge')

  .factory('stateChangeResolver', ['$state', '$window', '$rootScope', '$q',
    function ($state, $window, $rootScope, $q) {
      
      // Important notes:
      // - The event.preventDefault() could be called only once because only
      //   one handler (first in line, whilst order is not guaranteed) may call
      //   event.preventDefault() and all other handlers should rely
      //   on that. So, given the async nature of handlers invocation,
      //   this exposes a race condition.
      // - Calling $rootScope.$broadcast('$stateChangeSuccess', ...);
      //   will resume state transition no matter what handlers call
      //   event.preventDefault()
      // - The above things are the reason for this _centralized_
      //   stateChangeResolver component. This should be THE ONLY
      //   component that prevents state transitions with e.preventDefault()
      // - This component ensures that state transition only proceeds
      //   when all promises are resolved. If any promise is rejected,
      //   the state change will not occur.


      var handlers = [];
      var unlistenStateChangeFn;

      function resumeStateChange(toState, toStateParams, fromState, fromStateParams) {
        // Can't proceed to the state with unknown name
        if (!toState || !toState.name) return false;

        // Beware the dragons! See discussion for more detail:
        // https://github.com/angular-ui/ui-router/issues/178

        // Proceed to the state silently (notify: false)
        $state.go(toState.name, toStateParams, { notify: false }).then(function () {
          // And broadcast a "success" event upon transition complete
          $rootScope.$broadcast('$stateChangeSuccess', toState, toStateParams, fromState, fromStateParams);
        });
      }

      function unlistenStateChange() {
        if (unlistenStateChangeFn) {
          unlistenStateChangeFn();
          unlistenStateChangeFn = undefined;
        }
      }

      function listenStateChange() {
        if (unlistenStateChangeFn) return;

        unlistenStateChangeFn = $rootScope.$on('$stateChangeStart', function (e, toState, toStateParams, fromState, fromStateParams) {

          // General flow:
          // - Developers register handlers with `addHandler` method
          // - This conponent maintains an array of active handlers
          // - On $stateChangeStart event, it collects promises from handlers array
          // - If no promise is returned by handler - it considered sync and is ignored
          // - If handler didn't make event.preventDefault() its considered normal flow
          //   and the handler is ignored. Note that stateChangeResolver doesn't prevent
          //   the default event handling behavior (warning: don't call e.preventDefault()
          //   in async callback! This would lead to unexpected behavior).
          // - Only proceed to new state when all promises from async handlers are resolved
          // - Do nothing otherwise


          // Run handlers, handle results and collect promises
          var promises = [];

          _.each(handlers, function (handlerFn) {
            var result = handlerFn(e, toState, toStateParams, fromState, fromStateParams);

            // Result might be either a promise or a value; or none at all.
            // We only care if handler returns something
            if (result) promises.push($q.when(result));
          });

          // If the default behavior hasn't been prevented or there were no promises - do nothing
          if (!promises.length || !e.defaultPrevented) return;

          // Finally, wait for promises to resolve and proceed with a hacky transition imitation
          // Do nothing otherwise
          $q.all(promises).then(function () {
            resumeStateChange(toState, toStateParams, fromState, fromStateParams);
          });

        });
      }


      var resolver = {
        addHandler: function (handlerFn) {
          handlers.push(handlerFn);
          listenStateChange();

          return function () {
            resolver.removeHandler(handlerFn);
          };
        },

        removeHandler: function (handlerFn) {
          _.pull(handlers, handlerFn);
          if (!handlers.length) unlistenStateChange();
        }
      };

      return resolver;

    }]);
