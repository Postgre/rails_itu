class StaffCandidateSerializer < ActiveModel::Serializer
  attributes :id, :about, :is_visible, :city, :availability, :name, :country_iso3, :country, :is_profile_complete,
             :comments_size

  def country
    {id: object.country_iso3, name: Carmen::Country.coded(object.country_iso3).try(:name)}
  end
  has_one :user, serializer: StaffUserSerializer

  has_many :skill_records, serializer: SkillRecordSerializer
  has_many :skill_category_records, serializer: SkillCategoryRecordSerializer
  has_many :employment_records, serializer: EmploymentRecordSerializer
  has_many :education_records, serializer: EducationRecordSerializer
  has_many :comments, serializer: StaffCommentSerializer
  has_many :courses, serializer: CourseSerializer

  def name
    object.name
  end

  def comments
    object.root_comments
  end

  def comments_size
    object.comment_threads.size
  end
end
