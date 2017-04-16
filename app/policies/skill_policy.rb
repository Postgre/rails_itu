class SkillPolicy < ApplicationPolicy
  def index?
    staff_member?
  end

  def delete?
    staff_member?
  end

  def add_connected?
    staff_member?
  end
end
