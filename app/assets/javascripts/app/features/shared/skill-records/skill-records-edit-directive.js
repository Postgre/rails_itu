'use strict';

angular.module('bridge')

  // Reusable skill records edit directive

  /* Example:
   * <div class="content-padded" skill-records-edit skillable="job"></div>
   */

   .directive('skillRecordsEdit', ['appSettings', 'humanizedMsg', 'modalbox', 'modelize',
    function (appSettings, humanizedMsg, modalbox, modelize) {

      return {
        restrict: 'A',
        templateUrl: 'app/features/shared/skill-records/_skill-records-edit.html',
        scope: {
          'skillable': '='
        },
        controller: ['$scope', function ($scope) {
          $scope.getSkillIds = function() {
            if($scope.skillable.id) {
              return _.map($scope.skillable.skillRecords, function (r) { return r.skillId; });
            } else {
              return _.map($scope.skillable.skill_records_attributes, function (r) { return r.skillId; });
            }
          };
          $scope.select2skillOptions = {
            minimumInputLength: 2,
            query: function (query) {
              var _query = query;

              modelize('skills').query({
                query: query.term,
                'categoryIds[]': _.map($scope.skillCategoryRecords, function (r) {
                  return r.skillCategoryId;
                }),
                'skillIds[]': $scope.getSkillIds()
              }).then(function (data) {
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
        }],
        link: function ($scope, el, attrs) {
          $scope.skillCategories = modelize('skillCategories').all({ cache: true }).$future;
          $scope.skillLevels     = modelize('skill-levels').all({ cache: true }).$future;

          // Entity-related data
          $scope.skillCategoryRecords = $scope.skillable.skillCategoryRecords;

          if (!$scope.skillable.isNew()) {
            // Need to re-fetch because skillable.skillCategoryRecords doesn't
            // contain skillRecords for some reason
            $scope.skillCategoryRecords.fetch();
          }

          $scope.$watch('skillable', function(newVal) {
            if(angular.isDefined(newVal)) {
              if(_.isNumber($scope.skillable.id)) $scope.skillable.skill_records_attributes = undefined;
            }
          });

          // Skills management
          $scope.newSkill = null;

          $scope.addSkillOrRecord = function (skill) {
            if (!skill) return;

            if (_.isNumber(skill.id)) {
              $scope.addSkillRecord(skill);
            } else {
              modelize('skills').$new({ skill: { name: skill.id } }).save().then(function (skill) {
                $scope.addSkillRecord(skill);
              });
            }

            $scope.clearSearch();
          };

          $scope.addSkillRecord = function (skill) {
            if($scope.skillable.id) {
              // Ignore duplicates
              for (var i = 0; i < $scope.skillCategoryRecords.length; i++) {
                var skillCategoryRecord = $scope.skillCategoryRecords[i];
                if (skillCategoryRecord.skillRecords &&
                  skillCategoryRecord.skillRecords.any({ skillId: skill.id })) return;
              }

              // Same workaround as above
              return modelize.one($scope.skillable.resourceUrl()).many('skillRecords').$new({ skillId: skill.id }).save()
                .then(function (skillCategoryRecords) {
                  $scope.skillCategoryRecords.set(skillCategoryRecords, { remove: false });
                  $scope.clearSearch();

                  humanizedMsg.displayMsg('Skill successfully added');
                });
            } else {
              if(angular.isUndefined($scope.skillable.skill_records_attributes)) {
                $scope.skillable.skill_records_attributes = [];
              }
              $scope.skillable.skill_records_attributes.push({skillId: skill.id});
              var skillCategoryRecord = _.find($scope.skillCategoryRecords, function(category) {
                return category.skillCategoryId == skill.skillCategoryId;
              });

              if(angular.isDefined(skill.data)) skill = skill.data;

              var skillRecord = {id: 1, skillName: skill.name, skillId: skill.id, skillCategoryId: skill.skillCategoryId};
              if(angular.isUndefined(skillCategoryRecord)) {
                $scope.skillCategoryRecords.push({skillCategoryId: skill.skillCategoryId, skillCategoryName: skill.skillCategoryName, skillRecords: [skillRecord]});
              } else {
                skillRecord.id = _.size(skillCategoryRecord.skillRecords) + 1;
                skillCategoryRecord.skillRecords.push(skillRecord);
              }
            }
          };

          $scope.updateSkillRecord = function (skillRecord) {
            if($scope.skillable.id) {
              return skillRecord.save({ patch: true });
            } else {
              $scope.skillable.skill_records_attributes = _.without($scope.skillable.skill_records_attributes, _.find($scope.skillable.skill_records_attributes, function(skill) { return skill.skillID == skillRecord.skillId }));
              $scope.skillable.skill_records_attributes.push(skillRecord);
            }
          };

          $scope.removeSkillRecord = function (skillRecord) {
            if($scope.skillable.id) {
              skillRecord.destroy().then(function () {
                $scope.skillCategoryRecords.removeEmpty();
              });
            } else {
              $scope.skillable.skill_records_attributes = _.without($scope.skillable.skill_records_attributes, _.find($scope.skillable.skill_records_attributes, function(skill) { return skill.skillID == skillRecord.skillId }));
              var skillCategoryRecord = _.find($scope.skillCategoryRecords, function(category) {
                return category.skillCategoryId == skillRecord.skillCategoryId;
              });
              if(_.size(skillCategoryRecord.skillRecords) == 1) {
                $scope.skillCategoryRecords = _.without($scope.skillCategoryRecords, skillCategoryRecord);
              } else {
                skillCategoryRecord.skillRecords = _.without(skillCategoryRecord.skillRecords, _.find(skillCategoryRecord.skillRecords, function(skill) { return skill.skillId == skillRecord.skillId;}))
              }
            }
          };

          $scope.clearSearch = function () {
            $scope.newSkill = undefined;
          };

          $scope.isForJob = function() {
            $scope.skillable.baseUrl == '/jobs';
          };

          // Skills overview modal
          $scope.showSkillsOverview = function () {
            modalbox.open({
              templateUrl: 'app/features/shared/skill-records/_skills-overview-modal.html',
              resolve: {
                skillCategories: function () {
                  return modelize('skillCategories').all();
                },
                skills: function () {
                  return modelize('skills').all();
                }
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

          // Re-ordering functionality
          $scope.dropSuccessCategoryHandler = function ($event, index, category) {
            console.log('dropSuccessCategory',$event, index, category);
            if (!$scope.categoryToMove || !$scope.categoryToMove.id || $scope.categoryToMove === category) return;

            category.reorder($scope.categoryPositionOfDrop).then(function (skillCategoryRecords) {
              $scope.skillCategoryRecords.set(skillCategoryRecords);
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
              var skillCategoryRecord = $scope.skillCategoryRecords.where({ skillCategoryId: skill.skillCategoryId }, true);
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
        }
      };
    }]);
