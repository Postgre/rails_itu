'use strict';

angular.module('bridge').directive('comments', ['LoggedRestangular',
    function (LoggedRestangular) {
        return {
            restrict: 'A',
            templateUrl: 'common/directives/comments.html',
            scope: {
                commentableType:    '=',
                commentable:        '=',
                isStaff:            '='
            },
            link: function ($scope, element, attrs) {
                $scope.reply = {id: 0};
                $scope.newComment = {};
                $scope.sendComment = function sendComment(comment, parent) {
                    if (angular.isDefined(parent)) {
                        comment.parent_id = parent.id;
                    }
                    LoggedRestangular.setBaseUrl('/api/v1').all('comments').post({
                        resource: $scope.commentableType,
                        resource_id: $scope.commentable.id,
                        comment: comment}).then(function (res) {
                            $scope.commentable = res.data || res;
                            $scope.newComment = {};
                            $scope.reply = {id: 0};
                        }
                    );
                };
            }
        };
    }
]);
