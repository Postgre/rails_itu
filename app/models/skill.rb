class Skill < ActiveRecord::Base
  searchkick text_start: [:name], suggest: ['name']

  belongs_to :skill_category, foreign_key: :skill_category_id, class_name: 'SkillCategory'
  has_many :skill_records, dependent: :destroy
  has_many :jobs, through: :skill_records, :source => :skillable, :source_type => 'Job'
  has_many :candidates, through: :skill_records, :source => :skillable, :source_type => 'Candidate'

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :skill_category_id
end
