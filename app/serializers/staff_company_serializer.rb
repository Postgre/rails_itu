class StaffCompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :state, :logo_url, :company_size, :website, :city, :postal_code, :phone_number, :about_us,
             :street_address, :street_address2, :country, :country_iso3, :comments_size, :region, :transition_date,
             :created_at, :updated_at, :jobs_count, :hired_count

  has_one :industry
  has_many :users, serializer: StaffUserSerializer
  has_many :comments, serializer: StaffCommentSerializer

  TRANSITION_FOR_CURRENT_STATE = {
    'created' => 'create',
    'submitted' => 'submit',
    'accepted' => ['accept', 'unban'],
    'rejected' => 'reject',
    'banned' => 'ban'
  }

  def country
    {id: object.country_iso3, name: Carmen::Country.coded(object.country_iso3).try(:name)}
  end

  def transition_date
    return nil unless TRANSITION_FOR_CURRENT_STATE.keys.include?(object.state)
    object.versions.where(event: TRANSITION_FOR_CURRENT_STATE[object.state]).last.try(:created_at)
  end

  def comments
    object.root_comments
  end

  def comments_size
    object.comment_threads.size
  end

  def jobs_count
    object.jobs.size
  end

  def hired_count
    object.jobs.where(state: 'filled').size
  end
end
