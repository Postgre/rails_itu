class FavoriteJobSerializer < ActiveModel::Serializer
  has_one :creator, serializer: UserSerializer
end
