class CompanyPolicy < ApplicationPolicy

  class Scope
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def resolve
      return Company.all if user.has_role?(:staff)
      if user.has_role?(:candidate)
        Company.accepted
      else
        Company.with_role :representative, user
      end
    end
  end

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

  def unban?
    staff_member?
  end

  def show?
    record.accepted? || user.has_role?(:representative, record) || staff_member?
  end

  def manage?
    user.has_role?(:representative, record)
  end

  def comment?
    staff_member?
  end
end
