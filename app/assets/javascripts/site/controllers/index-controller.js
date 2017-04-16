'use strict';

angular.module('bridge').controller('IndexController', ['$scope', '$state', '$rootScope', '$cookies', '$window', 'appUrl', 'zendeskTicketModal', 'Restangular', '$anchorScroll', '$location',
  function ($scope, $state, $rootScope, $cookies, $window, appUrl, zendeskTicketModal, Restangular, $anchorScroll, $location) {
    $scope.showZendeskModal = function () {
      zendeskTicketModal.open();
    };

    $scope.hasEmptyFields = function(company) {
      var has_empty_fields = true;
      if(company && company.users_attributes){
        has_empty_fields = _.isEmpty(company.name);
        has_empty_fields = has_empty_fields || _.isEmpty(company.users_attributes.email);
        has_empty_fields = has_empty_fields || _.isEmpty(company.users_attributes.first_name);
        has_empty_fields = has_empty_fields || _.isEmpty(company.users_attributes.last_name);
        has_empty_fields = has_empty_fields || _.isEmpty(company.users_attributes.password);
        has_empty_fields = has_empty_fields || _.isEmpty(company.users_attributes.password_confirmation);
      }

      return has_empty_fields;
    };

    //if($cookies['access_token_cookie'] && !angular.isDefined($window.staticPage)) {
    //  $window.location.replace(appUrl);
    //}

    $scope.newCompanyRegistration = function (company) {
      var params = {};
      if(angular.isDefined($scope.newUser)) {
        params.user_id = $scope.newUser.id;
      }

      var company_params = null;
      if(company && company.users_attributes) {
        company_params = {company: {name: company.name, phone_number: company.phone_number, users_attributes: [company.users_attributes]}};
      } else {
        company_params = {company: {name: "", phone_number:null, users_attributes: {password:null,password_confirmation:null,first_name:null,last_name:null, email:null}}};
      }
      Restangular.all('companies').post(company_params, params).then(function(data) {
        $scope.errors = undefined;
        $window.location.href = appUrl;
      }, function(error) {
        $scope.errors = error.data.errors;
        $scope.newUser = error.data.user;
      });

    };

    $scope.scrollTo = function (id) {
      var old = $location.hash();
      $location.hash(id);
      $anchorScroll();
      //reset to old to keep any additional routing logic from kicking in
      $location.hash(old);
    };

    $scope.submitOrHighlightCheckbox = function (isAgreed, $event){
      if(isAgreed){
        $('#isAgreed').removeClass('checkbox-highlight-border');
      } else {
        $('#isAgreed').addClass('checkbox-highlight-border');
        $event.preventDefault();
      }
    }

}]);
