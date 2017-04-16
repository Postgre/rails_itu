require 'rails_helper'

describe App do

  context 'validations' do
    subject { FactoryGirl.build(:app) }
    it {should be_valid }
    it {should validate_presence_of(:name)}
  end

  it 'test after intilize ensure client id' do
    obj = App.allocate
    expect(obj).to receive(:ensure_client_id)
    obj.send(:initialize)
  end
end
