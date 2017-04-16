class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :database_authenticatable, :registerable, :recoverable, :rememberable
  devise :trackable
  acts_as_commentable
  acts_as_messageable
  rolify

  attr_accessor :password, :password_confirmation

  has_one :candidate
  has_one :avatar, as: :attachable, class_name: 'Asset'
  has_many :jobs
  has_many :interviews
  has_many :company_reps
  has_many :companies, through: :company_reps

  accepts_nested_attributes_for :candidate

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  before_create :create_itu_id_user

  def access_token
    @access_token ||= ItuIdUser.find(self.itu_id).access_token
  end

  def avatar_url
    begin
      URI.join(Rails.application.config.id_url, ItuIdUser.find(self.itu_id).avatar_url).to_s
    rescue
    end
  end

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  ransacker :fullname do |parent|
    Arel::Nodes::NamedFunction.new('concat_ws',
      [' ', parent.table[:first_name], parent.table[:last_name]])
  end

  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    return self.email
    #if false
    #return nil
  end

  # this needs to be cleaned up; if the API Service is down
  # users will have trouble accessing the system
  # we need to be able to either issue a temporary token to access the system or
  # queue the failed #create_itu_id_user to a job queue that can try and re-sync the accounts
  def create_itu_id_user
    return unless self.itu_id.nil? # We only need to do that if it's not here already.
    @itu_id_user = ItuIdUser.create(email: self.email,
                                    password: self.password,
                                    password_confirmation: self.password_confirmation)
    if @itu_id_user.persisted?
      self.itu_id = @itu_id_user.id
      Rails::Redis.hset(@itu_id_user.access_token, 'itu_id', @itu_id_user.id) # FIXME: we need that to streamline company creation process
    else
      @itu_id_user.errors.keys.each do |key|
        @itu_id_user.errors[key].each do |message|
          errors.add(key.to_sym, message)
        end
      end
      raise ActiveRecord::Rollback
    end
  end

  def candidate!
    Candidate.find_or_create_by!(user_id: self.id)
    self.add_role :candidate
  end

  def main_app_route
    return '/staff/dashboard' if self.has_role? :staff
    return '/app'
  end

  def active_for_authentication?
    super && !ItuIdUser.find(self.itu_id).is_blocked
  end
end
