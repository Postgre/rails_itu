class StaffSkillRecordSerializer < ActiveModel::Serializer
  attributes :id, :skillable_type, :skillable_id, :skillable_name

  def skillable_name
    return object.skillable.email if object.skillable_type == 'Candidate'
    return object.skillable.title if object.skillable_type == 'Job'
  end
end