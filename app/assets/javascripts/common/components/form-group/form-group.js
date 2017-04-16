'use strict';

angular.module('bridge')

  .directive('formGroup', ['$compile', '$parse', function ($compile, $parse) {

    // Custom transclusion (heavy DOM manipulations) helper
    var cloneMergeFn = function (el, clone, scope, transclusionScope, formGroupCtrl, formCtrl) {

      // Filter out text nodes (and other rubbish we don't need)
      var toInsert = _.filter(clone, function (clonedEl) {
        return clonedEl.nodeType !== 3;
      });

      // Handle label
      // Note: Only look if the first element in list is a <label>
      // and take its contents into [transclude-label] element

      var targetLabel = angular.element(el[0].querySelectorAll('[transclude-label]'));
      if (targetLabel) {
        var topEl = toInsert[0];

        // TODO: Corner-case alert - Make sure the label doesn't have the checkbox in it
        if (topEl && topEl.tagName && topEl.tagName.toLowerCase() === 'label') {
          var labelEl = angular.element(topEl);
          targetLabel.addClass(labelEl[0].className);
          targetLabel.prepend(labelEl.html());

          _.pull(toInsert, topEl);
        }
      }

      // Move everything else into [transclude-main] element

      var targetMain = angular.element(el[0].querySelectorAll('[transclude-main]'));
      if (targetMain) {
        if (toInsert && toInsert.length) {
          targetMain.empty();

          _.each(toInsert, function (someEl) {
            if (someEl) targetMain.append(someEl);
          });
        }
      }

      return el;
    };


    return {
      restrict: 'EA',
      scope: { },
      // priority: 2000,
      transclude: true,
      require: ['?^^form', 'formGroup'],
      templateUrl: function (tEl, tAttrs) {
        if (tAttrs.templateUrl) return tAttrs.templateUrl;

        if (tAttrs.templateStyle)
          return 'common/components/form-group/templates/_form-group-' + tAttrs.templateStyle + '.html';

        return 'common/components/form-group/templates/_form-group-default.html';
      },

      controller: ['$scope', '$element', '$attrs', function ($scope, $element, $attrs) {
        var ctrl = this;

        this.required = false;

        var unbindRequiredWatch;

        this.controlNames = [];
        this.controls     = [];
        this._ngModelAttrByName = {};

        this.addControl = function (control) {
          ctrl.controls.push(control);
        };

        this.isControlInvalid = function (control, form) {
          return control && control.$invalid && (control.$touched || (form && form.$submitted) || 
            (control.$error && !!control.$error.modelError));
        };

        this.isInvalid = function () {
          return _.any(ctrl.controls, ctrl.isControlInvalid);
        };

        this.setRequiredWatch = function (controlEl) {
          if (!controlEl) return;

          if (unbindRequiredWatch) unbindRequiredWatch();
          unbindRequiredWatch = $scope.$watch(function () {
            return controlEl.attr('required');
          }, function (newRequired) {
            if (ctrl.required !== newRequired) ctrl.required = newRequired;
          });
        };

        $scope.$on('$destroy', function () {
          ctrl.controls = null;
          ctrl.controlNames = null;

          if (unbindRequiredWatch) unbindRequiredWatch();

          // TODO: Remove transcluded elements
        });
      }],

      link: function (scope, el, attrs, ctrls, transcludeFn) {
        var formCtrl      = scope._form      = ctrls[0],
            formGroupCtrl = scope._formGroup = ctrls[1];

        // Make sure element has .form-group class (for convenience)
        el.addClass('form-group');

        // Do the dirty work
        transcludeFn(function (clone, transclusionScope) {
          cloneMergeFn(el, clone, scope, transclusionScope, formGroupCtrl, formCtrl);
        });

        // Handle ngModels

        var isFirstNgModel = true;

        angular.forEach(el.find('[ng-model]'), function (_controlEl) {
          var controlEl = angular.element(_controlEl);

          // Only add conventional class directly to input, select or textarea,
          // everything else should be set by the developer.
          var nodeName = controlEl.prop('nodeName');
          if (nodeName) nodeName = nodeName.toLowerCase();

          if (_.contains(['input', 'select', 'textarea'], nodeName) &&
              controlEl.prop('type') !== 'checkbox') controlEl.addClass('form-control');

          var controlName = controlEl.attr('name');
          var controlElId = controlEl.attr('id');
          var ngModelAttr = controlEl.attr('ng-model');


          if (!controlName) {
            // Try to infer name attribute from ng-model
            var propIndex = ngModelAttr.lastIndexOf('.'),
                modelName;

            if (propIndex !== -1) {
              modelName = ngModelAttr.substring(0, propIndex);
              controlName = ngModelAttr.substring(propIndex + 1);
            } else {
              controlName = ngModelAttr;
            }

            controlEl.attr('name', controlName);
          }

          if (controlName) {
            formGroupCtrl.controlNames.push(controlName);
            formGroupCtrl._ngModelAttrByName[controlName] = ngModelAttr;
          }

          if (!controlElId) {
            controlElId = _.uniqueId(controlName + '_');
            controlEl.attr('id', controlElId);
          }
            
          var elNgModelCtrl = controlEl.data('$ngModelController');
          if (elNgModelCtrl) {
            if (isFirstNgModel) {
              if (controlEl.attr('required') || controlEl.attr('ng-required')) formGroupCtrl.setRequiredWatch(controlEl);
              var labelRegion = angular.element(el[0].querySelectorAll('[transclude-label]'));
              if (labelRegion) labelRegion.attr('for', controlElId);
            }

            isFirstNgModel = false;

            if (!elNgModelCtrl.$name && controlName) {
              elNgModelCtrl.$name = controlName;
              formCtrl.$addControl(elNgModelCtrl);
            }

            formGroupCtrl.addControl(elNgModelCtrl);
          }
        });

        // View helper functions

        scope.hasError = function () {
          return _.any(formGroupCtrl.controlNames, function (controlName) {
            if (!controlName) return false;

            return formGroupCtrl.isControlInvalid(formCtrl[controlName], formCtrl);
          });
        };
      }
    };

  }])


  .directive('fieldErrors', ['$compile', '$parse', function ($compile, $parse) {

    return {
      restrict: 'EA',
      // priority: 1900,
      require: ['?^^formGroup', '?^^form'],
      transclude: true,
      scope: {},
      templateUrl: 'common/components/form-group/templates/_field-errors.html',
      link: function (scope, el, attrs, ctrls, transcludeFn) {
        var formGroupCtrl = ctrls[0],
            formCtrl      = ctrls[1];

        if (!formGroupCtrl || !formCtrl) return;

        // The related control is either explicitly specified as 'field-errors="someProp"'
        // or the first control added to formGroup is assumed if no attribute value
        // been provided
        scope.controlName = attrs.fieldErrors || formGroupCtrl.controlNames[0];

        scope.defaultErrorMessagesUrl = 'common/components/form-group/templates/_default-error-messages.html';
        scope.errorMessages = [];

        var outerScope;

        var initNgMessagesRef = function (controlName) {
          if (!controlName) return;
          scope.ngMessagesRef = formCtrl.$name + '.' + controlName + '.$error';
        };

        scope[formCtrl.$name] = formCtrl;

        // Event if this fails (in case control name was not explicitly specified
        // and there is no "first" control in formGroup), we fill up the messages anyway
        // to relate it to the first control on some consequent 'showErrors' check
        initNgMessagesRef(scope.controlName);

        // Transclusion just reads the cloned elements and fills up the errorMessages
        transcludeFn(function (clone, transclusionScope) {
          var messageElements = _.filter(clone, function (_el) { return _.any(_el.attributes, { name: 'field-error' }); });
          _.each(messageElements, function (msg) {
            var $msgEl = angular.element(msg);

            scope.errorMessages.push({
              type: $msgEl.attr('field-error'),
              message: $msgEl.html()
            });
          });

          outerScope = transclusionScope;
        });

        scope.showErrors = function () {
          if (!scope.controlName) scope.controlName = formGroupCtrl.controlNames[0];
          if (!scope.controlName) return false;
          if (!scope.ngMessagesRef) initNgMessagesRef(scope.controlName);

          return formGroupCtrl.isControlInvalid(formCtrl[scope.controlName], formCtrl);
        };

        scope.getModelErrors = function () {
          if (!outerScope) return [];

          var ngModelAttr = formGroupCtrl._ngModelAttrByName[scope.controlName];
          if (ngModelAttr) {
            var attrNameArray = ngModelAttr.split('.'),
                modelErrorRef;

            // Should be at least 2 chunks.
            // If so, splice '$modelErrors' attribute name in,
            // right before the last chunk.
            if (attrNameArray.length >= 2) {
              attrNameArray.splice(attrNameArray.length - 1, 0, '$modelErrors');
              modelErrorRef = attrNameArray.join('.');
            }

            if (modelErrorRef) return $parse(modelErrorRef)(outerScope);
          }

          return [];
        };
      }
    };

  }]);

