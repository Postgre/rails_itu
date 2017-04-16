'use strict';

angular.module('bridge').directive('courseListItem', [function () {
  return {
    restrict: 'EA',
    replace: true,
    templateUrl: 'app/features/courses/templates/_course-list-item.html',
    scope: {
      course: '=',
      readonly: '='
    },

    link: function (scope, el, attrs) {

    }
  };
}]);
