class StaffSkillDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :skill_category_id, :skill_category_name, :skill_records_count

  has_many :skill_records, serializer: StaffSkillRecordSerializer
  has_many :contained_skills, serializer: SkillSerializer

  def skill_category_name
    object.skill_category.name
  end

  def contained_skills
    Skill.where(name: object.name.split(',').map(&:strip)).where.not(id: object.id)
  end
end