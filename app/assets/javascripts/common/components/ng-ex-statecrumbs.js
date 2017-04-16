// Auto-breadcrumbs generation component.
// - Mostly a refactored fork of uiBreadcrumbs
//   https://github.com/michaelbromley/angularUtils/tree/master/src/directives/uiBreadcrumbs
// - Works in conjunction with `uiRouter`.

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

  var defaultLabelProperty    = 'breadcrumb.label',
      defaultStateRefProperty = 'breadcrumb.stateRef';

  // Note: 'ui.router' dependency is assumed, but not enforced here due to AMD quirks
  return angular.module('ngExStatecrumbs', [])

    .directive('ngExStatecrumbs', ['$interpolate', '$parse', '$state', function ($interpolate, $parse, $state) {
      return {
        restrict: 'EA',
        scope: {
          labelProperty: '@?',
          stateRefProperty: '@?'
        },
        templateUrl: 'common/components/templates/statecrumbs.html',
        link: function (scope, el, attrs) {
          var labelProperty    = scope.labelProperty || defaultLabelProperty,
              stateRefProperty = scope.stateRefProperty || defaultStateRefProperty,
              rootLabel        = attrs.rootLabel,
              rootUrl          = attrs.rootUrl;


          // Internal helper functions

          function _getObjectPropertyValue (obj, propPath) {
            if (!obj) return obj;

            var propNames = propPath.split('.');
            var prop = obj;

            for (var i = 0; i < propNames.length; i++) {
              if (!angular.isDefined(prop[propNames[i]])) return undefined;

              // Going one level deeper
              prop = prop[propNames[i]];
            }

            return prop;
          }

          function _hasState (breadcrumbs, state) {
            if (!state) return false;

            for (var i = 0; i < breadcrumbs.length; i++) {
              if (breadcrumbs[i].state === state.name) return true;
            }

            return false;
          }

          function _generateBreadcrumbs () {
            var state = $state.$current,
                breadcrumbs = [],
                targetState;

            while (state && state.name !== '') {
              var label = _getObjectPropertyValue(state, labelProperty);
              var refStateName = _getObjectPropertyValue(state, stateRefProperty);

              if (state.self && state.self.breadcrumb && (label || refStateName)) {
                targetState = refStateName ? $state.get(refStateName) : null;

                if (targetState && !label) label = _getObjectPropertyValue(targetState, labelProperty);

                if (!targetState) {
                  // just throw for abstract states
                  if (state.abstract) {
                    throw new Error('The breadcrumb cannot be generated for abstract state "' + state + '" ' +
                                    'because no target state is set for its breadcrumb (`' + stateRefProperty + '` parameter). ' +
                                    'Either specify that or remove the `breadcrumb` property altogether.');
                  } else {
                    // Just set targetState to current for others
                    targetState = state;
                  }
                }

                if (!_hasState(breadcrumbs, state) && (label && targetState)) {
                  var interpolationContext = state.locals ? state.locals.globals : state;

                  label = $interpolate(label)(interpolationContext);

                  breadcrumbs.unshift({
                    label: label,
                    state: state.name,
                    refState: targetState.name
                  });
                }
              }

              targetState = null;
              state = state.parent;
            }

            // If root label is provided - make it into breadcrumbs, not tied to any state
            if (rootLabel) {
              breadcrumbs.unshift({
                label: rootLabel,
                url: rootUrl || '/'
              });
            }

            return breadcrumbs;
          }

          function _resetBreadcrumbs () {
            scope.breadcrumbs = _generateBreadcrumbs();
          }


          // Do useful stuff

          scope.breadcrumbs = [];

          if ($state.$current.name !== '') _resetBreadcrumbs();

          scope.$on('$stateChangeSuccess', function () {
            _resetBreadcrumbs();
          });
        }
      };
    }]);

}));
