'use strict';

/**
 * Module to fetch "look-up" data (for select lists, etc).
 * Supposed to fetch any data of different type but in the short form
 * which is enough for <select> lists.
 *
 * WARNING! Think if it is better to use specialized services for that.
 */

angular.module('bridge')

  .factory('lookupData', ['$q', 'modelize', function ($q, modelize) {

    function getLookupData(url, mapFn, options) {
      if (typeof mapFn === 'object') {
        options = mapFn;
        mapFn = undefined;
      }

      options = options || {};
      options.params = options.params || {};

      // options.fields to request particular fields from backend on request
      if (!options.fields && options.fields !== false) {
        options.params.fields = ['id', 'name'];
      }

      // Breakdown:
      // - Make $http request
      // - Handle any common HTTP errors
      // - Process/map data and return

      var requestData = angular.extend({}, options.data);

      if (options.fields) {
        requestData.fields = options.fields.join(',');
      }

      return modelize.$request.get(url, { data: requestData }).then(function (data) {
        if (typeof mapFn === 'function' && Array.isArray(data) && data.length) {
          var mappedData = [];

          data.forEach(function (item) {
            var mappedItem = mapFn(item);

            if (!mappedItem) {
              mappedData.push(mappedItem);
            }
          });

          return mappedData;
        }

        return data;
      });
    }


    return {

      getTimeZones: function () {
        return getLookupData('/time-zones', { fields: false });
      },

      getCountries: function () {
        return getLookupData('/countries');
      },

      getSkillCategories: function () {
        return getLookupData('/skill-categories');
      },

      getSkills: function () {
        return getLookupData('/skills');
      },

      getSkillLevels: function () {
        return getLookupData('/skill-levels', { fields: false, cache: true });
      },

      getYearsOfExperience: function (max) {
        var yearsOfExperienceList = [];

        // TODO: Implement 'year/years' inflection
        for (var i = 1; i <= (max || 20); i++) {
          yearsOfExperienceList.push({ value: i, name: i + ' years' });
        }

        return $q.when(yearsOfExperienceList);
      },

      getAvailabilityOptions: function () {
        return getLookupData('/availability-options', { fields: false, cache: true });
      }

    };

  }]);
