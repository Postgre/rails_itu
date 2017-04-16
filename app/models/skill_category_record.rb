class SkillCategoryRecord < ActiveRecord::Base
	belongs_to :skill_category
	has_many   :skills, through: :skill_category #, source: :skill
	has_many   :skill_records

	belongs_to :skill_categorizable, polymorphic: true
	acts_as_list scope: :skill_categorizable

	validates :skill_category_id, presence: true
	validates :skill_categorizable_type, presence: true
	validates :skill_categorizable_id, presence: true
	validates_uniqueness_of :skill_category_id, scope: [:skill_categorizable_type, :skill_categorizable_id]
end
