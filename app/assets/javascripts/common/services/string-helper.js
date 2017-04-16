'use strict';

angular.module('bridge')

  .factory('stringHelper', function () {

    // Thanks, Ember :)
    var STRING_CAMELIZE_REGEXP = (/(\-|_|\.|\s)+(.)?/g);
    var STRING_DECAMELIZE_REGEXP = (/([a-z\d])([A-Z])/g);

    var _transformProperties = function (obj, transformFn) {
      // FormData corner case fix
      // TODO: Need to transform field name somehow though:
      // Content-Disposition: form-data; name="someCustomData"
      if (FormData && obj instanceof FormData) return obj;

      if (angular.isArray(obj)) {
        var resultArr = [];
        angular.forEach(obj, function (value, key) {
          resultArr.push(_transformProperties(value, transformFn));
        });

        return resultArr;
      }

      if (angular.isObject(obj)) {
        var resultObj = {};
        for (var prop in obj) {
          if (typeof obj[prop] === 'function') {
            resultObj[prop] = obj[prop].bind(obj);
          } else {
            var transformedKey = transformFn(prop);
            resultObj[transformedKey] = _transformProperties(obj[prop], transformFn);
          }
        }

        return resultObj;
      }

      return obj;
    };


    var stringHelper = {

      camelize: function (str) {
        if (angular.isString(str)) {
          return str.replace(STRING_CAMELIZE_REGEXP, function(match, separator, chr) {
            return chr ? chr.toUpperCase() : '';
          }).replace(/^([A-Z])/, function(match, separator, chr) {
            return match.toLowerCase();
          });
        }

        return str;
      },

      decamelize: function (str) {
        if (angular.isString(str)) {
          return str.replace(STRING_DECAMELIZE_REGEXP, '$1_$2').toLowerCase();
        }

        return str;
      },

      camelizeProperties: function (obj) {
        return _transformProperties(obj, stringHelper.camelize);
      },

      decamelizeProperties: function (obj) {
        return _transformProperties(obj, stringHelper.decamelize);
      }
    };

    return stringHelper;

  });