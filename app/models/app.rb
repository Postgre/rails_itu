class App < ActiveRecord::Base
  validates :name, presence: true

  after_initialize :ensure_client_id, if: :new_record?
  scope :find_app, ->(client_id) { where('client_id = ?', client_id) }

  def ensure_client_id
    self.client_id = generate_client_id if client_id.blank?
  end

  private

  def generate_client_id
    loop do
      token = SecureRandom.hex
      break token unless self.class.exists?(client_id: token)
    end
  end
end
