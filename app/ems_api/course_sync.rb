class CourseSync < SyncBase
  def initialize(ems_student, candidate)
    @ems_student = ems_student
    @candidate   = candidate
  end

  def sync!
    @ems_student.courseterm_students.each do |ems_course|
      course = create_or_update_course(ems_course)
      if course.persisted?
        logger.info format('Course Created Candidate_id= %s', @candidate.id)
      else
        logger.warn format_error_message(course)
      end
    end
  end

  def create_or_update_course(ems_course)
    course_attributes = { ems_courseterm_student_id: ems_course.id,
                          title: ems_course.title.nil? ? "Course Title unavailable" : ems_course.title,
                          department: ems_course.department.blank? ? "Department unavailable" : ems_course.department,
                          professor: ems_course.professor.blank? ? "Professor unavailable" : ems_course.professor.join(", "),
                          description: ems_course.description.blank? ? "Description unavailable" : ems_course.description,
                          semester: ems_course.semester,
                          grade: ems_course.grade,
                          is_visible: true
                        }

    course = @candidate.courses.find_by_ems_courseterm_student_id(ems_course.id)

    if course.present?
      course.update(course_attributes)
    else
      course = @candidate.courses.create(course_attributes)
    end

    course
  end

  def format_error_message(course)
    format(
      "Ems_student_id=%s Candidate_id=%s\n%s",
      @ems_student.id,
      @candidate.id,
      ErrorsWithAttributes.new(course).to_s
    )
  end
end
