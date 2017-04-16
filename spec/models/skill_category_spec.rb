require 'rails_helper'

describe SkillCategory do
  subject { create(:skill_category) }
  it {should have_many(:skills) }
end
