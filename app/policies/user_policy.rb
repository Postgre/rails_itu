class UserPolicy < ApplicationPolicy
  def index?
    staff_member?
  end

  def reject?
    staff_member?
  end

  def accept?
    staff_member?
  end

  def ban?
    staff_member?
  end

  def show?
    staff_member?
  end

  def become?
    staff_member?
  end

  def comment?
    staff_member?
  end

  def stats?
    staff_member?
  end

  def message?
    staff_member?
  end
end
