class SkillRecordTreeSerializer < ActiveModel::Serializer
  attributes :id, :skill_id, :skill_name, :years_of_experience, :level, :skill_category_id, :is_featured, :position

  def skill_name
    object.skill.name
  end

  def skill_category_id
    object.skill.skill_category_id
  end
end
