class Course < ActiveRecord::Base
  belongs_to :candidate

  validates :candidate_id, presence: true
  validates :title , presence: true
  validates :description , presence: true
  validates :semester , presence: true
  validates :professor, presence: true
  validates :department , presence: true

  scope :visible, -> { where(is_visible: true) }
end
