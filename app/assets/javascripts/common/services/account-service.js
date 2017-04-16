'use strict';

angular.module('bridge').factory('accountService', ['LoggedRestangular', '$q', function (LoggedRestangular, $q) {
    var _accountAPI = LoggedRestangular.setBaseUrl('/api/v1').one('account'),
        _account    = _accountAPI.get().$object;

    return {
      setUnreadCount: function(count) {
        if(angular.isDefined(_account.unreadMessagesCount)) { //FIXME
          _account.unreadMessagesCount = count;
        } else {
          _account.unread_messages_count = count;
        }
      },
      getAccount: function (force) {
        if (force === true) {
          _account = _accountAPI.get().$object;
          return _account;
        } else {
          return _account;
        }
      },
      name: function () {
        return [_account.firstName, _account.middleName, _account.lastName].join(' ');
      },
      avatarUrl: function () {
        return _account.avatarUrl;
      },
      userType: function() {
        return _account.userType;
      }
    };
}]);