// Promise tracker component for AngularJS
// A fixed version of https://github.com/ajoslin/angular-promise-tracker

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

  return angular.module('ngExPromiseTracker', [])

    .provider('promiseTracker', function () {
      // var trackers = {};

      this.$get = ['$q', '$timeout', function($q, $timeout) {

        function cancelTimeout(promise) {
          if (promise) {
            $timeout.cancel(promise);
          }
        }

        return function PromiseTracker(options) {
          // Do new if user doesn't
          if (!(this instanceof PromiseTracker)) {
            return new PromiseTracker(options);
          }

          options = options || {};

          var _this = this;

          // Array of promises being tracked
          var tracked = [];

          // Allow an optional "minimum duration" that the tracker has to stay active for.
          var minDuration = options.minDuration;

          // Allow a delay that will stop the tracker from activating until that time is reached
          var activationDelay = options.activationDelay;

          var minDurationPromise;
          var activationDelayPromise;

          this.active = function () {
            // Even if we have a promise in our tracker, we aren't active until delay is elapsed
            if (activationDelayPromise) {
              return false;
            }
            return tracked.length > 0;
          };

          this.tracking = function () {
            //Even if we aren't active, we could still have a promise in our tracker
            return tracked.length > 0;
          };

          this.destroy = this.cancel = function () {
            minDurationPromise = cancelTimeout(minDurationPromise);
            activationDelayPromise = cancelTimeout(activationDelayPromise);
            for (var i=tracked.length-1; i>=0; i--) {
              tracked[i].resolve();
            }
            tracked.length = 0;
          };

          //Create a promise that will make our tracker active until it is resolved.
          // @return deferred - our deferred object that is being tracked
          this.createPromise = function () {

            function startMinDuration() {
              if (minDuration) {
                minDurationPromise = $timeout(angular.noop, minDuration);
              }
            }

            //Create a callback for when this promise is done. It will remove our
            //tracked promise from the array if once minDuration is complete
            function onDone(isError) {
              return function(value) {
                (minDurationPromise || $q.when()).then(function () {
                  var index = tracked.indexOf(deferred);
                  tracked.splice(index, 1);

                  //If this is the last promise, cleanup the timeouts
                  //for activationDelay
                  if (tracked.length === 0) {
                    activationDelayPromise = cancelTimeout(activationDelayPromise);
                  }
                });
              };
            }


            var deferred = $q.defer();
            tracked.push(deferred);
            //If the tracker was just inactive and this the first in the list of
            //promises, we reset our delay and minDuration
            //again.
            if (tracked.length === 1) {
              if (activationDelay) {
                activationDelayPromise = $timeout(function () {
                  activationDelayPromise = cancelTimeout(activationDelayPromise);
                  startMinDuration();
                }, activationDelay);
              } else {
                startMinDuration();
              }
            }

            deferred.promise.then(onDone(false), onDone(true));

            return deferred;

            
          };

          this.addPromise = function (promise) {
            var _promise, _then;

            if (promise) {
              _then = promise.then || promise.$then;
              if (_then) {
                _promise = promise;
              } else {
                _then = promise.$promise && promise.$promise.then;
                _promise = promise.$promise;
              }
            }

            if (!_then) {
              throw new Error('promiseTracker#addPromise expects a promise object!');
            }

            var deferred = _this.createPromise();

            // When given promise is done, resolve our created promise
            // Allow $then for angular-resource objects
            // then.apply(promise, function success(value) {
            _then.call(_promise, function success(value) {
              deferred.resolve(value);
              return value;
            }, function error(value) {
              deferred.reject(value);
              return $q.reject(value);
            });

            return deferred;
          };
        };
      }];

    });


}));
