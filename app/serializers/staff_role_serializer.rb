class StaffRoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :resource_type, :resource_id, :resource_name

  def resource_name
    object.try(:resource).try(:name)
  end
end
