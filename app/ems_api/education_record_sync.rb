class EducationRecordSync < SyncBase

  def initialize(ems_student, candidate)
    @ems_student = ems_student
    @candidate   = candidate
  end

  def sync!
    @ems_student.degree_histories.each do |degree|
      education_record = create_education_record(degree)
      if education_record.persisted?
        logger.info format('Education Record Created Candidate_id= %s', @candidate.id)
      else
        logger.warn format_error_message(education_record)
      end
    end
  end

  def create_education_record(degree)
    education_record = @candidate.education_records.find_or_create_by(school: 'ITU',
                                                        degree: degree.degree,
                                                        field_of_study: degree.field_of_study.nil? ? "Field of study unavailable" : degree.field_of_study,
                                                        city: degree.city,
                                                        region: degree.region,
                                                        country_id: degree.country_id,
                                                        country_iso3: degree.country_iso3,
                                                        start_year: degree.start_year.nil? ? nil : degree.start_year.to_date.year.to_i,
                                                        end_year: degree.end_year.nil? ? nil : degree.end_year.to_date.year.to_i,
                                                        has_graduated: degree.has_graduated,
                                                        is_verified: degree.is_verified)
    education_record
  end

  def format_error_message(education_record)
    format(
      "Ems_student_id=%s Candidate_id=%s\n%s",
       @ems_student.id,
       @candidate.id,
       ErrorsWithAttributes.new(education_record).to_s
      )
  end

end
