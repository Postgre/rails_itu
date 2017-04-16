require 'net/http'
class UserSync < SyncBase

  def initialize(term_id=65)
   @term_id = term_id
  end

  #sync unique particular user
  def sync!(ems_student)
    ems_student = EmsStudent.find(ems_student.id)
    if ems_student.present?
      candidate   = create_or_update_user(ems_student)
      EducationRecordSync.new(ems_student, candidate).sync!
    end
  end

  #sync all users
  def sync_all!
    page = 1
    while page
      ems_students = EmsStudent.find(:all, params: { per_page: 100, page: page, term_id: @term_id })
      page = next_page(ems_students.http_response['X-total'],
                       ems_students.http_response['X-offset'],
                       ems_students.http_response['X-limit'],
                       page)

      ems_students.each do |ems_student|
        candidate = create_or_update_user(ems_student)
        EducationRecordSync.new(ems_student, candidate).sync!
        CourseSync.new(ems_student, candidate).sync!
      end
    end
  end

  def sync_all_from_local!
    Candidate.where('ems_student_id is not null').all.each {|c| UserSync.new.sync!(EmsStudent.find(c.ems_student_id))}
  end

  def create_or_update_itu_id_user(itu_user_params,user=nil)
    if user && valid_itu_id?(user.itu_id)
      itu_id_user = ItuIdUser.find(user.itu_id)
      itu_id_user.update_attributes itu_user_params

      itu_id_user
    else
      itu_id_user = ItuIdUser.create(itu_user_params)
      itu_id_user
    end
  end

  def create_or_update_user(ems_student)
    avatar = {}
    if (ems_student.user.image_url != '/assets/anonymous_avatar.png') &&
       ::EmsUserAvatarUrlValidator.valid?(ems_student.user.image_url)
      avatar =  {remote_avatar_url: ems_student.user.image_url}
    end

    password = SecureRandom.hex(10) # For future validations

    itu_user_params = {
      ems_user_id: ems_student.user.id,
      email: ems_student.user.email,
      encrypted_password: ems_student.user.encrypted_password,
      password_salt: ems_student.user.password_salt
    }.merge(avatar) #quick hack or anonymous_avatar cases

    user_attributes = {
                       ems_id: ems_student.ems_id,
                       ems_user_id: ems_student.user.id,
                       email: ems_student.user.email,
                       first_name: ems_student.first_name,
                       middle_name: ems_student.middle_name,
                       last_name: ems_student.last_name,
                       password: password,
                       password_confirmation: password
                     }

   user = User.find_by_ems_user_id(ems_student.user.id)

   if user.present?
     itu_id_user     = create_or_update_itu_id_user(itu_user_params,user)
     user.update_attributes(user_attributes.merge(itu_id: itu_id_user.id))
     user
   else
     itu_id_user = create_or_update_itu_id_user(itu_user_params)
     user        = User.create(user_attributes.merge(itu_id: itu_id_user.id))
     user
   end

   candidate = create_or_update_candidate(user,ems_student)
  end

  def create_or_update_candidate(user,ems_student)
    user.candidate!
    logger.info format("Candidate record created/updated for user= %s", user.email)
    user.candidate.update_attribute :ems_student_id, ems_student.id if user.candidate.ems_student_id != ems_student.id

    user.candidate
  end

  private
    def next_page(total, offset, limit, page)
      next_page = (total.to_i / limit.to_i).floor > offset.to_i / limit.to_i ? page + 1 : nil
    end

    # this is a hack; we are assuming that a record
    # with an integer value will have a corresponding itu-id record
    # this is bad (FIXME)
    def valid_itu_id?(id)
      id.to_i.to_s == id
    end
end
