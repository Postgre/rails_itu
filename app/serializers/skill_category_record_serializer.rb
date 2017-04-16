# GET /candidate/skill-category-records
# [
#   {
#     "id": 1,
#     "skillCategoryId": 201,
#     "skillCategoryName": "Management",
#   }
# ]
class SkillCategoryRecordSerializer < ActiveModel::Serializer
  attributes :id, :skill_category_name, :skill_category_id, :position

  has_many :skill_records, serializer: SkillRecordTreeSerializer

  def skill_category_name
    object.skill_category.name
  end
end
