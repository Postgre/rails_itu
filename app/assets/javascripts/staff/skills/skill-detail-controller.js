'use strict';

angular.module('bridge').controller('SkillDetailController', ['$scope', '$state', 'LoggedRestangular', '$stateParams', 'stringHelper', 'modelize', function( $scope, $state, LoggedRestangular, $stateParams, stringHelper, modelize ) {
  $scope.added = {skills: []};

  LoggedRestangular.setBaseUrl('/api/v1/staff').one('skills', $stateParams.id).get().then(function(response) {
      $scope.skill = stringHelper.camelizeProperties(response);
  });

  $scope.getSkillIds = function() {
    return [];
  };

  $scope.select2skillOptions = {
    minimumInputLength: 2,
    query: function (query) {
      var _query = query;

      LoggedRestangular.setBaseUrl('/api/v1/staff').all('skills').getList({
        query: query.term,
        'skillIds[]': $scope.getSkillIds()
      }).then(function (data) {
        var data = stringHelper.camelizeProperties(data);
        var results = [];

        _.each(data, function (skill, index, list) {
          results.push({ id: skill.id, text: skill.name + ' (' + skill.skillCategoryName + ')', data: skill });
        });

        if (!_.contains(_.map(data, function (skill) {
          return skill.name;
        }), _query.term)) {
          results.push({ id: _query.term, text: 'Create skill "' + _query.term + '"' });
        }

        _query.callback({ results: results });
      });
    }
  };

  $scope.alreadyAdded = function(skill) {
    return _.contains($scope.added.skills, skill.id);
  };

  $scope.clearSearch = function () {
    $scope.newSkill = undefined;
  };

  $scope.addSkillOrRecord = function (skill) {
    if (!skill) return;

    if (_.isNumber(skill.id)) {
      $scope.addSkillRecord(skill);
    } else {
      LoggedRestangular.all('skills').post({ skill: { name: skill.id } }).then(function(skill) {
        var skill = stringHelper.camelizeProperties(skill);
        $scope.addSkillRecord(skill);
      });
    }

    $scope.clearSearch();
  };

  $scope.addSkillRecord = function (skill) {
    LoggedRestangular.setBaseUrl('/api/v1/staff').one('skills', $stateParams.id)
      .customPUT({skill_id: skill.id}, 'add-skill').then(function(res) {
        if(!_.contains($scope.added.skills, skill.id)) { // FIXME: we need better implementation for this. May be REDIS store on API.
          $scope.added.skills.push(skill.id);
        }
    });
  };

  $scope.delete = function(skill) {
    LoggedRestangular.setBaseUrl('/api/v1/staff').one('skills', $stateParams.id).remove().then(function(res) {
      $scope.reload();
      $state.go('skills');
    });
  }
}]);
