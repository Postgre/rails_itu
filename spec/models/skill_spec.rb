require 'rails_helper'

describe Skill do
  subject {  FactoryGirl.build(:skill)  }
  it { should be_valid }
  it { should validate_presence_of(:name)}
  it { should have_many(:skill_records)}
  it { should belong_to(:skill_category)}
end
