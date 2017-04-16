class Asset < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true     
  validates  :attachable_type, presence: { error_code: 9001,
                                           developer_message: I18n.t('validations.developer_message.required'),
                                           more_info: I18n.t('name.required.more_info') }
  validates  :attachable_id,presence: { error_code: 9001,
                                        developer_message: I18n.t('validations.developer_message.required'),
                                        more_info: I18n.t('name.required.more_info') }
end
