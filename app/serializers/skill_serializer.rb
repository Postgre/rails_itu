class SkillSerializer < ActiveModel::Serializer
  attributes :id, :name, :skill_category_id, :skill_category_name

  def skill_category_name
    object.skill_category.name
  end
end