class TimeZone < ActiveRecord::Base
  validates :name, presence: { error_code: 9001,
                               developer_message: I18n.t('validations.developer_message.required'),
                               more_info: I18n.t('name.required.more_info')
                              }
end
