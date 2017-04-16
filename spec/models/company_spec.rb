require 'rails_helper'

describe Company do
  let(:company) { FactoryGirl.build(:company) }
  it { expect(company).to be_valid }

  it { expect have_many(:interviews) }

  it { expect have_many(:users) }
end
