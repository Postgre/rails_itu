'use strict';

angular.module('bridge')
  .directive('companyListItem', ['humanizedMsg', 'become', 'modelize',
    function (humanizedMsg, become, modelize) {
      return {
        restrict: 'EA',
        replace: true,
        templateUrl: 'app/features/shared/companies/templates/_company-list-item.html',
        scope: {
          company: '=',
          aspect: '@'
        },

        link: function (scope, el, attrs) {
          scope.become = function(user) {
            become.become(user);
          };

          scope.isCandidateViewing = function () {
            // Candidate aspect is default
            return !scope.aspect || scope.aspect === 'candidate';
          };

          scope.isStaffViewing = function () {
            return scope.aspect === 'staff';
          };

          scope.toggleFavorite = function (company) {
            if(company.isFavorited) {
              company.unfavorite({ url: modelize.one('company', company.id).resourceUrl() + '/favorite' });
            } else {
              company.favorite({ url: modelize.one('company', company.id).resourceUrl() + '/favorite' });
            }
          };

        }
      };
    }]);
