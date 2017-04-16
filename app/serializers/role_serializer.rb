class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :resource_type, :resource_id, :resource_name, :resource_logo

  def resource_name
    object.resource.try(:name)
  end

  def resource_logo
    object.resource.logo.url if object.resource.is_a? Company
  end
end
