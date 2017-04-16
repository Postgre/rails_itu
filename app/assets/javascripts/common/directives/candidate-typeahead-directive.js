'use strict';

angular.module('bridge').directive('candidateTypeahead', ['Restangular', '$filter',
    function (Restangular, $filter) {
        return {
            restrict: 'A',
            templateUrl: 'common/directives/candidate-typeahead.html',
            scope: {
              selected: '='
            },
            link: function ($scope, element, attrs) {
              $scope.getCandidates = function getCandidates(viewValue) {
                if (angular.isUndefined(viewValue) || viewValue === '') return;

                return Restangular.setBaseUrl('/api/v1/staff').all('candidates')
                  .getList({q: {user_first_name_or_user_last_name_or_user_fullname_cont: viewValue}, lightweight: true})
                  .then(function(response) {
                    _.each(response, function(candidate) {
                      candidate.label = candidate.name;
                    });
                    return response;
                  });
              };
            }
        };
    }
]);
