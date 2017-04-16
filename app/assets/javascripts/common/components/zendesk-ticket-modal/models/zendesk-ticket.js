'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    modelize.defineModel('zendeskTicket', {
      baseUrl: '/zendesk',

      subject: '',
      body: ''
    });
  }])

  .factory('ZendeskTicket', ['modelize', function (modelize) {
    return modelize('zendeskTicket').$modelClass;
  }]);
