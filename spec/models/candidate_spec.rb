require 'rails_helper'

describe Candidate do

  context 'validations' do
    subject { FactoryGirl.build(:candidate) }
    it {should be_valid }
    it {should belong_to(:user) }
    it {should validate_presence_of(:user_id)}
  end
end
