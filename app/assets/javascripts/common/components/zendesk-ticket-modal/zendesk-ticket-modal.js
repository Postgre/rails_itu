'use strict';

angular.module('bridge')

  .factory('zendeskTicketModal', ['modalbox', 'modelize', '$q', 'humanizedMsg', 'currentUser',
    function (modalbox, modelize, $q, humanizedMsg, currentUser) {

      return {
        open: function (options) {
          options = options || {};

          var modal = modalbox.open({
            templateUrl: 'common/components/zendesk-ticket-modal/templates/_zendesk-ticket-modal.html',

            controller: ['$scope', 'modelize', 'modalboxInstance', function ($scope, modelize, modalboxInstance) {

              $scope.model = modelize('zendeskTickets').$new();

              $scope.createZendeskTicket = function (zendeskTicket) {
                zendeskTicket.save().then(function () {
                  modalboxInstance.close(zendeskTicket);
                  humanizedMsg.displayMsg('Ticket has been created');
                });
              };

              $scope.isLoading = function () {
                return $scope.model.$loading;
              };

              $scope.isAnonymousUser = function () {
                return !currentUser.isAuthenticated;
              };

            }]
          });

          return modal;

        }
      };
    }]);
