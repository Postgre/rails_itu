class JobPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope, :company

    def initialize(user, scope, company)
      @user = user
      @scope = scope
      @company = company
    end

    def resolve
      if user.has_role?(:representative, company)
        scope.all
      else
        scope.visible
      end
    end
  end

  def show?
    user.has_role?(:representative, record.company) ||
      (record.is_public && record.published?) ||
      (user.candidate && user.candidate.interviews.where(job_id: record.id).any?) ||
      staff_member?
  end

  def manage?
    user.has_role?(:representative, record.company)
  end

  def action?
    user.has_role?(:representative, record.company) && (record.state_events.size > 0)
  end

  def index?
    staff_member?
  end

  def comment?
    staff_member?
  end

  def recommend?
    staff_member?
  end

  def flag?
    staff_member?
  end

  def apply?
    record.is_public && record.published? && user.has_role?(:candidate)
  end
end
