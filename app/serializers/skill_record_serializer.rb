
class SkillRecordSerializer < ActiveModel::Serializer
  attributes :id, :skill_category_id, :skill_id, :skill_name, :years_of_experience, :level, :is_featured, :matched, :position

  def skill_name
    object.skill.name
  end

  def skill_category_id
   object.skill.skill_category_id
  end

  def matched
    return false unless scope.is_a? Job
    scope.skill_records.pluck(:skill_id).include?(object.skill_id)
  end
end
