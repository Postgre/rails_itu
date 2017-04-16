'use strict';

angular.module('bridge')

  .directive('commentListForm', ['appSettings', 'modelize',
    function (appSettings, modelize) {

      return {
        restrict: 'EA',
        templateUrl: 'app/features/shared/comments/templates/_comment-list-form.html',
        replace: true,
        scope: {
          commentable: '=',
          commentableType: '@',
          comments: '=commentCollection',
          currentUser: '=',
          onCancel: '&',
          onSuccess: '&',
          parentComment: '='
        },

        link: function (scope, el, attrs) {
          scope.comment = {};

          scope.postComment = function () {
            var comment = scope.comment;

            if (!comment) return;

            if (scope.parentComment && scope.parentComment.id) comment.parentId = scope.parentComment.id;

            return modelize.$request.post('/comments', {
              resource: scope.commentableType,
              resourceId: scope.commentable.id,
              comment: comment
            }).then(function (newCommentable) {
              // TODO: Make API return just added comment instead of entire "commentable"
              scope.commentable.comments = newCommentable.comments;
              scope.clearForm();
              if (scope.onSuccess) scope.onSuccess();

              return newCommentable.comments;
            });
          };

          scope.clearForm = function () {
            scope.comment = {};
          };

          scope.cancel = function () {
            scope.clearForm();
            if (scope.onCancel) scope.onCancel();
          };

          scope.canBeSubmitted = function () {
            return scope.comment && !!scope.comment.body;
          };
        }
      };
    }]);
