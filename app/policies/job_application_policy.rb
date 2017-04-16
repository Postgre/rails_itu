class JobApplicationPolicy < ApplicationPolicy
  def show?
    record.candidate_id == user.candidate.id
  end

  def manage?
    record.candidate_id == user.candidate.id
  end

  def interact?
    user.has_role?(:representative, record.job.company)
  end
end
