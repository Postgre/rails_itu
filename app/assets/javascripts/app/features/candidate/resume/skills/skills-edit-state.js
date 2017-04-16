'use strict';

angular.module('bridge')

  .config(['$stateProvider', 'appSettings', function ($stateProvider, appSettings) {

    $stateProvider.state('candidate.resume.skills.edit', {

      url: '/edit',
      templateUrl: appSettings.appPaths.features + '/candidate/resume/skills/templates/edit.html',

      controllerAs: 'skillsEditCtrl',

      controller: ['$scope', 'skillLevels', 'lookupData', 'Skill', 'CandidateSkillCategoryRecord', 'CandidateSkillRecord', 'humanizedMsg', 'modalbox', 'promiseTracker', 'Restangular',
        function ($scope, skillLevels, lookupData, Skill, CandidateSkillCategoryRecord, CandidateSkillRecord, humanizedMsg, modalbox, promiseTracker, Restangular) {

          var _this = this,
              loadingTracker = promiseTracker();

          // Common data

          this.skillCategories = [];
          lookupData.getSkillCategories().then(function (skillCategories) {
            _this.skillCategories = skillCategories;
          });

          this.skillLevels = skillLevels;
          lookupData.getSkillLevels().then(function (skillLevels) {
            _this.skillLevels = skillLevels;
          });

          this.yearsOfExperienceList = [];
          lookupData.getYearsOfExperience().then(function (years) {
            _this.yearsOfExperienceList = years;
          });


          // Entity-related data
          
          this.skillCategoryRecords = CandidateSkillCategoryRecord.$newCollection();

          var promise = CandidateSkillCategoryRecord.all();
          loadingTracker.addPromise(promise);

          promise.then(function (skillCategoryRecords) {
            _this.skillCategoryRecords = skillCategoryRecords;
          });

          // Skills management

          // TODO: Hacky workaround, think about how to hide somewhere (directive?)
          $scope.newSkill = null;

          $scope.select2skillOptions = {
            minimumInputLength: 2,
            query: function (query) {
              var _query = query;
              
              Skill.query({
                query: query.term,
                'categoryIds[]': _.map(_this.skillCategoryRecords, function (r) { return r.skillCategoryId; })

              }).then(function (data) {
                var results = [];

                _.each(data, function (skill, index, list) {
                  results.push({ id: skill.id, text: skill.name + ' (' + skill.skillCategoryName + ')' });
                });

                if(!_.contains(_.map(data, function (skill) { return skill.name; }), _query.term)) {
                  results.push({ id: _query.term, text: 'Create skill "' + _query.term + '"' });
                }

                _query.callback({ results: results });
              });
            }
          };

          $scope.dropSuccessCategoryHandler = function ($event, index, category) {
            console.log('dropSuccessCategory',$event, index, category);
            if (!$scope.categoryToMove || !$scope.categoryToMove.id || $scope.categoryToMove === category) return;

            category.reorder($scope.categoryPositionOfDrop).then(function (skillCategoryRecords) {
              _this.skillCategoryRecords.set(skillCategoryRecords);
            });
          };

          $scope.onDropCategory = function ($event, $data, category) {
            console.log('onDropCategory',$event, $data, category);
            $scope.categoryToMove = category;
            $scope.categoryPositionOfDrop = category.position;
          };

          $scope.dropSuccessSkillHandler = function ($event, index, skill) {
            console.log('dropSuccessSkill',$event, index, skill);
            if (!$scope.skillToMove || !$scope.skillToMove.id || $scope.skillToMove === skill) return;

            skill.reorder($scope.skillPositionOfDrop).then(function (skillRecords) {
              var skillCategoryRecord = _this.skillCategoryRecords.where({ skillCategoryId: skill.skillCategoryId }, true);
              if (skillCategoryRecord) {
                skillCategoryRecord.skillRecords.reset(skillRecords);
              }
            });
          };

          $scope.onDropSkill = function ($event, $data, skill) {
            console.log('onDropSkill',$event, $data, skill);
            $scope.skillToMove = skill;
            $scope.skillPositionOfDrop = skill.position;
          };

          this.addSkillOrRecord = function (skillIdOrName) {
            if (!skillIdOrName) return;

            if (_.isNumber(skillIdOrName)) {
              _this.addSkillRecord(skillIdOrName);
            } else {
              Skill.$new({skill: { name: skillIdOrName }}).save().then(function (skill) {
                _this.addSkillRecord(skill.id);
              });
            }

            _this.clearSearch();
          };

          this.addSkillRecord = function (skillId) {
            // Ignore duplicates
            for (var i = 0; i < _this.skillCategoryRecords.length; i++) {
              var skillCategoryRecord = _this.skillCategoryRecords[i];
              if (skillCategoryRecord.skillRecords &&
                  skillCategoryRecord.skillRecords.any({ skillId: skillId })) return;
            }

            var newRecordPromise = CandidateSkillCategoryRecord.addSkillRecord({ skillId: skillId });
            loadingTracker.addPromise(newRecordPromise);

            newRecordPromise.then(function (skillCategoryRecords) {
              _this.skillCategoryRecords.set(skillCategoryRecords, { remove: false });
              _this.clearSearch();

              humanizedMsg.displayMsg('Skill successfully added');
            });
          };

          this.updateSkillRecord = function (skillRecord) {
            return skillRecord.save({ patch: true });
          };

          this.removeSkillRecord = function (skillRecord) {
            skillRecord.destroy().then(function () {
              _this.skillCategoryRecords.removeEmpty();
            });
          };

          this.clearSearch = function () {
            $scope.newSkill = undefined;
          };


          // Skills overview modal

          this.showSkillsOverview = function () {
            modalbox.open({
              templateUrl: appSettings.appPaths.features + '/candidate/resume/skills/templates/_skills-overview-modal.html',
              resolve: {
                skillCategories: ['SkillCategory', function (SkillCategory) {
                  return SkillCategory.all();
                }],
                skills: ['Skill', function (Skill) {
                  return Skill.all();
                }]
              },

              controller: ['$scope', '$filter', 'skillCategories', 'skills', function ($scope, $filter, skillCategories, skills) {
                $scope.skillCategories = skillCategories;
                $scope.skills = skills;

                $scope.currentSkillCategory = $filter('orderBy')($scope.skillCategories, function (sc) { return sc.name; })[0];

                $scope.setCurrentSkillCategory = function (skillCategory) {
                  $scope.currentSkillCategory = skillCategory;
                };
              }]
            });
          };

          this.isListLoading = function () {
            return loadingTracker.active();
          };

        }]
    });

  }]);
