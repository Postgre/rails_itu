class StaffSkillSerializer < ActiveModel::Serializer
  attributes :id, :name, :skill_category_id, :skill_category_name, :skill_records_count

  def skill_category_name
    object.skill_category.name
  end
end