class SkillCategory < ActiveRecord::Base
  searchkick
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :skills
  accepts_nested_attributes_for :skills
end
