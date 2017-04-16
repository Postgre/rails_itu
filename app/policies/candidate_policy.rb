class CandidatePolicy < ApplicationPolicy
  def index?
    staff_member?
  end

  def show?
    staff_member? or company_rep? or (user.candidate.id == record.id)
  end

  def update?
    staff_member? or (user.candidate.id == record.id)
  end

  def comment?
    staff_member?
  end
end
