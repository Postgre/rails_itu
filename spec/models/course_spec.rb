require 'rails_helper'

describe Course do
  it { should validate_presence_of(:candidate_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:semester) }
  it { should validate_presence_of(:department) }
  it { should validate_presence_of(:professor) }
  it { should validate_presence_of(:description) }
end
