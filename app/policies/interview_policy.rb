class InterviewPolicy < ApplicationPolicy
  def show?
    user.has_role?(:representative, record.job.company) || user.candidate.interviews.where(id: record.id).any?
  end

  def interact?
    (user.has_role?(:representative, record.job.company) || user.candidate.interviews.where(id: record.id).any?) &&
        record.job.published? && (record.state_events.size > 0)
  end

  def comment?
    interact?
  end

  def manage?
    user.has_role?(:representative, record.job.company) && record.job.published? && (record.state_events.size > 0)
  end

  def action?
    user.has_role?(:representative, record.job.company)
  end

  def permitted_events
    if manage?
      [:change_time, :cancel, :miss, :hire]
    elsif interact?
      [:accept, :reject, :reject_time]
    else
      []
    end
  end
end
