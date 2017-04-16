'use strict';

angular.module('bridge')

  .factory('statReport', ['LoggedRestangular', function (LoggedRestangular) {
    return {
      getStats: function () {
        return LoggedRestangular.setBaseUrl('/api/v1/staff').oneUrl('stats').get().then(function (statData) {
          var stats = {
            companies: [],
            candidates: []
          };

          for (var i = 0; i < statData.length; i++) {
            if (statData[i].companies) stats.companies = _.clone(statData[i].companies);
            if (statData[i].candidates) stats.candidates = _.clone(statData[i].candidates);
          }

          return stats;
        });
      }
    }
  }])

  .directive('statDashboard', ['statReport', function (statReport) {

    return {
      restrict: 'EA',
      scope: {},
      templateUrl: 'common/components/stat-dashboard/templates/_stat-dashboard-simple.html',
      link: function (scope, el, attrs) {
        scope.stats = {};

        statReport.getStats().then(function (stats) {
          scope.stats = stats;
        });

        scope.isLoading = function () {
          return !scope.stats || scope.stats.$loading;
        };
      }
    };

  }]);
