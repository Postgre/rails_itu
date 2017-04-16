'use strict';

angular.module('bridge')

  .directive('commentListFor', ['appSettings', 'modelize', 'currentUser',
    function (appSettings, modelize, currentUser) {

      return {
        restrict: 'EA',
        templateUrl: appSettings.appPaths.features + '/shared/comments/templates/_comment-list.html',
        scope: {
          commentable: '=commentListFor',
          commentableType: '@',
          tree: '@',
          readonly: '@'
        },

        link: function (scope, el, attrs) {
          scope.currentUser = {};

          currentUser.getAccount().then(function (account) {
            scope.currentUser = account;
          });

          // Aspect helpers

          scope.isCompanyViewing = function () {
            return scope.aspect === 'company';
          };

          scope.isCandidateViewing = function () {
            return scope.aspect === 'candidate';
          };

          scope.isStaffViewing = function () {
            return scope.aspect === 'staff';
          };

          // Other helpers

          scope.isCurrentUserComment = function (comment) {
            if (!scope.currentUser || !comment || !comment.user) return false;

            if (comment.user.id && scope.currentUser.id === comment.user.id) return true;

            return false;
          };

          // Reply feature

          scope.replyCommentId = '';

          scope.isReplyFormShownFor = function (comment) {
            return scope.replyCommentId && scope.replyCommentId === comment.id;
          };

          scope.showReplyFormFor = function (comment) {
            if (!comment) return;

            scope.replyCommentId = comment.id;
          };

          scope.hideReplyForm = function () {
            scope.replyCommentId = '';
          };

          scope.toggleReplyFormFor = function (comment) {
            if (!comment) return;

            if (scope.isReplyFormShownFor(comment)) {
              scope.hideReplyForm();
            } else {
              scope.showReplyFormFor(comment);
            }
          };
        }
      };
    }]);
