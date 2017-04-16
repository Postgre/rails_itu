class CandidateInterviewSerializer < ActiveModel::Serializer
  attributes :id, :location, :date, :state, :details, :possible_events, :can_be_commented
  has_one :company
  has_one :job
  has_many :comments, serializer: CommentSerializer

  def possible_events
    Pundit.policy(scope, object).permitted_events & object.state_events
  end

  def comments
    object.root_comments
  end

  def can_be_commented
    object.job.published? && (object.state_events.size > 0)
  end
end