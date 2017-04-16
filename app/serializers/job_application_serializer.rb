class JobApplicationSerializer < ActiveModel::Serializer
  attributes :id, :cover_letter, :state, :resume_url, :resume_file_name

  has_one :candidate, serializer: CandidateSerializer

  def resume_url
    object.resume.url
  end

  def resume_file_name
    File.basename(object.resume.url)
  end
end