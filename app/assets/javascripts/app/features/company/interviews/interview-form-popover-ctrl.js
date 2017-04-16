'use strict';

angular.module('bridge')

  .controller('InterviewFormPopoverCtrl', ['$scope', '$stateParams', 'modelize', 'humanizedMsg', 'LoggedRestangular',
    function ($scope, $stateParams, modelize, humanizedMsg, LoggedRestangular) {
      // Note: Assuming that 'company', 'candidate' and 'job' exist in the parent scope!

      // "Invite" scenario only for now
      $scope.isEdit = false;

      $scope.model = modelize.one('company', $scope.company.id).one('job', $scope.job.id).many('interviews').$new({
        company: $scope.company,
        job: $scope.job,
        candidate: $scope.candidate
      });

      $scope.submit = function () {
        // Might be extended to 'create vs update' based on 'isEdit'
        return $scope.create($scope.model);
      };

      $scope.create = function (model) {
        return model.save().then(function () {
          if ($scope.candidate) $scope.candidate.isInvited = true;
          humanizedMsg.displayMsg('Interview successfully created');

          $scope.complete();
        });
      };

      $scope.complete = function () {
        // Either redirect or close modal, popover, or whatever
        $scope.$hide();
        $scope.acceptApplication();
      };

      $scope.formIsLoading = function () {
        return $scope.model && $scope.model.$loading;
      };

      $scope.getAddresses = function (searchString) {
        if (!searchString) return [];

        return LoggedRestangular.all('geocoder').getList({ q: searchString }).then(function (res) {
          return LoggedRestangular.stripRestangular(res);
        });
      };


    }]);
