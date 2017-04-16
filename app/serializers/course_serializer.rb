class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :department, :professor, :description, :semester, :is_visible, :grade
end