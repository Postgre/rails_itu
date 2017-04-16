class InterviewSerializer < ActiveModel::Serializer
  attributes :id, :location, :date, :state, :possible_events, :comments_size, :details, :candidate,
             :location, :latitude, :longitude, :can_be_commented

  has_many :comments, serializer: CommentSerializer
  has_one :company
  has_one :job

  def candidate
    CandidateSerializer.new(object.candidate, scope: object.job)
  end

  def possible_events
    Pundit.policy(scope, object).permitted_events & object.state_events
  end

  def comments
    object.root_comments
  end

  def comments_size
    object.comment_threads.size
  end

  def can_be_commented
    object.job.published? && (object.state_events.size > 0)
  end
end