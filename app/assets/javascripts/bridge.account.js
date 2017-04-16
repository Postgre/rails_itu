'use strict';

angular.module('bridge.account').config([
  '$stateProvider', function($stateProvider) {
    return $stateProvider.state("account", {
      abstract: true,
      url: "/account",
      template: ""
    }).state("account.index", {
      url: "",
      templateUrl: "/index.html"
    }).state("account.edit", {
      url: "/edit",
      templateUrl: "/edit.html"
    }).state("account.change-password", {
      url: "/change-password",
      templateUrl: "/change-password.html"
    });
  }
]);
