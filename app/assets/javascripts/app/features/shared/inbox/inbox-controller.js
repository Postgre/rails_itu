'use strict';

var InboxController = function($scope, LoggedRestangular, accountService, stringHelper){
  var _this = this;

  LoggedRestangular.setBaseUrl('/api/v1').all('conversations').getList().then(function(res) {
    _this.conversations = _.map(res, function (item) {
      if(angular.isUndefined(item.lastResponder)) {
        return stringHelper.camelizeProperties(item);
      } else {
        return item;
      }
    });
  });
  _this.newMessage = {};

  $scope.toggleDisplay = function(conversation){
    if(angular.isUndefined(conversation.expanded)) conversation.expanded = false;
    conversation.expanded = !conversation.expanded;
    if(conversation.expanded && _.contains(_.map(conversation.receipts, function(r) { return r.isRead;}), false)) {
      LoggedRestangular.setBaseUrl('/api/v1').one('conversations', conversation.id).customOperation('patch','mark_as_read')
        .then(function(res) {
          accountService.setUnreadCount(res.unread);
          conversation.isRead = true;
        });
    }
  };

  $scope.reply = function(conversation){
    LoggedRestangular.setBaseUrl('/api/v1').one('conversations', conversation.id).customPUT({body: _this.newMessage.body},'reply')
      .then(function(response) {
        response.expanded = true;
        conversation.reply = false;
        conversation.receipts.push(response);
        _this.newMessage = {};
      });
  };
};

InboxController.$inject = ['$scope', 'LoggedRestangular', 'accountService', 'stringHelper'];

angular.module('bridge').controller('InboxController', InboxController)
  .config(['$stateProvider', function ($stateProvider) {
    $stateProvider.state('inbox', {
      abstract: false,
      url: '/inbox',
      templateUrl: 'app/features/shared/inbox/list.html',
      controller: 'InboxController',
      controllerAs: 'inbox'
    });
}]);
