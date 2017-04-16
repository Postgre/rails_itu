class SkillRecord < ActiveRecord::Base
  SKILL_LEVELS =   [
      {value: 0, name: 'Beginner'},
      {value: 1, name: 'Intermediate'},
      {value: 2, name: 'Good'},
      {value: 3, name: 'Strong'},
      {value: 4, name: 'Expert'}
    ]

  belongs_to :skill, counter_cache: true
  belongs_to :skillable, polymorphic: true, touch: true
  belongs_to :skill_category_record
  acts_as_list scope: :skill_category_record

  validates :level, presence: true
  validates :years_of_experience, presence: true
  validates :skill_id, presence: true
  validates :skillable, associated: true
  validates :skill, associated: true
  # validates :skill_category_record, associated: true
  validates_uniqueness_of :skill_id, scope: [:skillable_id, :skillable_type]

  scope :featured, -> { where(is_featured: true) }

  after_create :set_category_record
  before_create :add_to_redis
  after_destroy :delete_category_record
  after_destroy :remove_from_redis

  def set_category_record
    skill_category_record = self.skillable.skill_category_records.where(skill_category_id: self.skill.skill_category_id).first_or_create
    self.update_attribute :skill_category_record_id, skill_category_record.id
  end

  def delete_category_record
    self.skillable.skill_category_records.where(skill_category_id: self.skill.skill_category_id).destroy_all if self.skillable.skills.where(skill_category_id: self.skill.skill_category_id).size == 0
  end

  def add_to_redis
    Rails::Redis.sadd("skill:#{self.skill_id}:#{self.skillable_type}:ids", self.skillable.id) if skillable.try(:id)
    Rails::Redis.sadd("#{self.skillable_type}:#{self.skillable_id}:skills", self.skill_id) if skillable.try(:id)
    Rails::Redis.zadd("skill:#{self.skill_id}:#{self.skillable_type}:scores", self.try(:position), self.skillable.id) if skillable.try(:id)
    true
  end

  def remove_from_redis
    Rails::Redis.srem("skill:#{self.skill_id}:#{self.skillable_type}:ids", self.skillable.id)
    Rails::Redis.srem("#{self.skillable_type}:#{self.skillable_id}:skills", self.skill_id)
    Rails::Redis.zrem("skill:#{self.skill_id}:#{self.skillable_type}:scores", self.skillable.id)
  end
end
