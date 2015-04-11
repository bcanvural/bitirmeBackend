class ApiController < ApplicationController
  http_basic_authenticate_with name:ENV["API_AUTH_NAME"], password:ENV["API_AUTH_PASSWORD"], :only => [:signup, :get_token]
  before_filter :check_for_valid_authtoken, :except => [:signup, :signin, :get_token]

  require 'rubygems'
  require 'rqrcode'

  def signup
    if request.post?
      if params && params[:full_name] && params[:email] && params[:password]

        params[:user] = Hash.new
        params[:user][:first_name] = params[:full_name].split(" ").first
        params[:user][:last_name] = params[:full_name].split(" ").last
        params[:user][:email] = params[:email]

        begin
          decrypted_pass = AESCrypt.decrypt(params[:password], ENV["API_AUTH_PASSWORD"])
        rescue Exception => e
          decrypted_pass = nil
        end

        params[:user][:password] = decrypted_pass
        params[:user][:verification_code] = rand_string(20)

        user = User.new(user_params)

        if user.save
          render :json => user.to_json, :status => 200
        else
          error_str = ""

          user.errors.each{|attr, msg|
            error_str += "#{attr} - #{msg},"
          }

          e = Error.new(:status => 400, :message => error_str)
          render :json => e.to_json, :status => 400
        end
      else
        e = Error.new(:status => 400, :message => "required parameters are missing")
        render :json => e.to_json, :status => 400
      end
    end
  end

  def signin
    if request.post?
      if params && params[:email] && params[:password]
        user = User.where(:email => params[:email]).first

        if user
          if User.authenticate(params[:email], params[:password])

            if !user.api_authtoken || user.api_authtoken == ""
              auth_token = rand_string(20)
              auth_expiry = Time.now + (24*60*60)

              user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)
            end

            render :json => user.to_json, :status => 200
          else
            e = Error.new(:status => 401, :message => "Wrong Password")
            render :json => e.to_json, :status => 401
          end
        else
          e = Error.new(:status => 400, :message => "No USER found by this email ID")
          render :json => e.to_json, :status => 400
        end
      else
        e = Error.new(:status => 400, :message => "required parameters are missing")
        render :json => e.to_json, :status => 400
      end
    end
  end

  def reset_password
    if request.post?
      if params && params[:old_password] && params[:new_password]
        if @user
          if @user.authtoken_expiry > Time.now
            authenticate_user = User.authenticate(@user.email, params[:old_password])

            if authenticate_user && !authenticate_user.nil?
              auth_token = rand_string(20)
              auth_expiry = Time.now + (24*60*60)

              begin
                new_password = AESCrypt.decrypt(params[:new_password], ENV["API_AUTH_PASSWORD"])
              rescue Exception => e
                new_password = nil
                puts "error - #{e.message}"
              end

              new_password_salt = BCrypt::Engine.generate_salt
              new_password_digest = BCrypt::Engine.hash_secret(new_password, new_password_salt)

              @user.update_attributes(:password => new_password, :api_authtoken => auth_token, :authtoken_expiry => auth_expiry, :password_salt => new_password_salt, :password_hash => new_password_digest)
              render :json => @user.to_json, :status => 200
            else
              e = Error.new(:status => 401, :message => "Wrong Password")
              render :json => e.to_json, :status => 401
            end
          else
            e = Error.new(:status => 401, :message => "Authtoken is invalid or has expired. Kindly refresh the token and try again!")
            render :json => e.to_json, :status => 401
          end
        else
          e = Error.new(:status => 400, :message => "No user record found for this email ID")
          render :json => e.to_json, :status => 400
        end
      else
        e = Error.new(:status => 400, :message => "required parameters are missing")
        render :json => e.to_json, :status => 400
      end
    end
  end

  def get_token
    if params && params[:email]
      user = User.where(:email => params[:email]).first

      if user
        if !user.api_authtoken || (user.api_authtoken && user.authtoken_expiry < Time.now)
          auth_token = rand_string(20)
          auth_expiry = Time.now + (24*60*60)

          user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)
        end

        render :json => user.to_json(:only => [:api_authtoken, :authtoken_expiry])
      else
        e = Error.new(:status => 400, :message => "No user record found for this email ID")
        render :json => e.to_json, :status => 400
      end

    else
      e = Error.new(:status => 400, :message => "required parameters are missing")
      render :json => e.to_json, :status => 400
    end
  end

  def clear_token
    if @user.api_authtoken && @user.authtoken_expiry > Time.now
      @user.update_attributes(:api_authtoken => nil, :authtoken_expiry => nil)

      m = Message.new(:status => 200, :message => "Token cleared")
      render :json => m.to_json, :status => 200
    else
      e = Error.new(:status => 401, :message => "You don't have permission to do this task")
      render :json => e.to_json, :status => 401
    end
  end



  def get_user
    if params && params[:email]
      user = User.where(:email => params[:email]).first
      render :json => user.to_json, :status => 200
    end
  end


  def get_courses
    courses = Array.new
    if @user.student?
      studentcourses = StudentCourse.where(:user_id=>@user.id)
      studentcourses.each do |sc|
        courses.push(Course.where(:id=>sc.course_id).first)
      end
    else
      courses = Course.where(:user_id => @user.id)
    end
    render :json => courses.to_json, :status => 200
  end

  def create_lecturesession_by_course_id
    if request.post?
      if params && params[:course_id]
        generate_qrcode(params[:course_id])
        if Course.where(:id=>params[:course_id]) #such a course exists
          ls = LectureSession.new(:course_id=>params[:course_id],
                                  :user_id=>@user.id,
                                  :qrcode=>@qrcode_string)
          if ls.save
            render :json => ls.to_json, :status => 200 #created
          else
            e = Error.new(:status => 400, :message => "Cannot create lecture session.")
            render :json => e.to_json, :status => 400
          end
        end
      end
    end
  end


    def attend
      if request.post?
        if params && params[:qrcode]
          ls = LectureSession.where(:qrcode=>params[:qrcode])
          if ls && ls.qrcode==params[:qrcode]
            qrcode_parsed = ls.qrcode.split(',')
            if Time.now - qrcode_parsed[0] < 10*60*60
              attendance = Attendance.new(:lecture_session_id=>ls.id,
                                          :user_id=>@user.id)
              if attendance.save
                render :json => attendance.to_json, :status => 201 #created
              else
                e = Error.new(:status => 400, :message => "Cannot create attendance.")
                render :json => e.to_json, :status => 400
              end
            else
              e = Error.new(:status => 400, :message => "Too late to give attendance.")
              render :json => e.to_json, :status => 400
            end
          else
            #no lecturesessin or qrcode mismatch
            e = Error.new(:status => 400, :message => "No such lecturesession or qrcode mismatch")
            render :json => e.to_json, :status => 400
          end
        else
          e = Error.new(:status => 400, :message => "Bad request")
          render :json => e.to_json, :status => 400
        end
      end

    end

    def get_user_attendance_by_course_id
      if params && params[:course_id]
        ce_array = CourseEntity.where(:course_id => params[:course_id])
        attendance_array = []
        ce_array.each do |ce|
          attendance_array.push(AttendanceList.where(:course_entity_id => ce.id,:user_id => @user.id))
        end
        render :json => attendance_array.to_json, :status => 200
      else
        e = Error.new(:status => 400, :message => "Bad request")
        render :json => e.to_json, :status => 400
      end
    end

    def get_lecture_sessions_by_course_id
      if params && params[:course_id]
        ls_array = LectureSession.where(:course_id => params[:course_id])
        render :json => ls_array.to_json, :status => 200
      else
        e = Error.new(:status => 400, :message => "Bad request")
        render :json => e.to_json, :status => 400
      end
    end

    def get_student_list_by_lecture_session_id
      if params && params[:course_id]
        course_entities_array = CourseEntity.where(:course_id => params[:course_id])
        attendances = []
        course_entities_array.each do |ce|
           attendances = AttendanceList.where(:course_entity_id => ce)
        end
        #attendances = Attendance.where(:lecture_session_id => params[:lecture_session_id])
        users = []
        attendances.each do |attendance|
          users.push(User.where(:id=>attendance.user_id).select(:first_name,:last_name,:email))
        end
        render :json => users.to_json, :status => 200
      end
    end

    def get_attended_sessions_by_course_id
      if params && params[:course_id]
        puts "inside get_attended... course id is:#{params[:course_id]} "
        ce_array = CourseEntity.where(:course_id => params[:course_id])
        attendances= []
        ce_array.each do |ce|
          attendances.push(AttendanceList.where(:course_entity_id => ce.id,:user_id => @user.id).first())
          puts "First Attendance:#{attendances}"
        end
        #render :json=> (generate_lecture_session_custom_json attendances.count ,attendances, CourseEntity.where(:course_id=>params[:course_id])), :status => 200
        render :json => attendances.to_json, :status => 200
      else
        puts "inside else in get_attended_sessions..."
        e = Error.new(:status => 400, :message => "Bad request")
        render :json => e.to_json, :status => 400
      end

    end

  # def update_location_info
  #   if request.post? && params && params[:loc_x] && params[:loc_y]
  #     ul = UserLocation.where(:user_id=>@user.id)
  #     if ul
  #       ul.loc_x = params[:loc_x]; ul.loc_y = params[:loc_y]
  #       ul.update_last_viewed_at  get_time
  #       ul.save
  #       render :json => ul.to_json, :status => 200
  #     else
  #       ul = UserLocation.new(:user_id=>@user.id,
  #                             :loc_x => params[:loc_x],
  #                             :loc_y => params[:loc_y])
  #       ul.save
  #       render :json => ul.to_json, :status => 200
  #     end
  #   else
  #     e = Error.new(:status => 400, :message => "Bad request")
  #     render :json => e.to_json, :status => 400
  #   end
  # end

    private

  def generate_lecture_session_custom_json count ,attendance, all_sessions
    require 'json'
    lecture_session_custom = {:lecture_session_count => count,
                              :attendance => attendance,
                              :all_sessions => all_sessions}
    return JSON.generate(lecture_session_custom)
  end
    def check_for_valid_authtoken
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:api_authtoken => token).first
      end
    end

    def rand_string(len)
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
      string  =  (0..len).map{ o[rand(o.length)]  }.join
      return string
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_hash, :password_salt, :verification_code,
                                   :email_verification, :api_authtoken, :authtoken_expiry, :instructor, :student)
    end

    def photo_params
      params.require(:photo).permit(:name, :title, :user_id, :random_id, :image_url)
    end

    def generate_qrcode(course_id)

      @qrcode = RQRCode::QRCode.new("#{Time.now.to_i},#{course_id}")
      @qrcode_string = ("#{Time.now.to_i},#{course_id}")
    end



  end


#
# def upload_photo
#   if request.post?
#     if params[:title] && params[:image]
#       if @user && @user.authtoken_expiry > Time.now
#         rand_id = rand_string(40)
#         image_name = params[:image].original_filename
#         image = params[:image].read
#
#         s3 = AWS::S3.new
#
#         if s3
#           bucket = s3.buckets[ENV["S3_BUCKET_NAME"]]
#
#           if !bucket
#             bucket = s3.buckets.create(ENV["S3_BUCKET_NAME"])
#           end
#
#           s3_obj = bucket.objects[rand_id]
#           s3_obj.write(image, :acl => :public_read)
#           image_url = s3_obj.public_url.to_s
#
#           photo = Photo.new(:name => image_name, :user_id => @user.id, :title => params[:title], :image_url => image_url, :random_id => rand_id)
#
#           if photo.save
#             render :json => photo.to_json
#           else
#             error_str = ""
#
#             photo.errors.each{|attr, msg|
#               error_str += "#{attr} - #{msg},"
#             }
#
#             e = Error.new(:status => 400, :message => error_str)
#             render :json => e.to_json, :status => 400
#           end
#         else
#           e = Error.new(:status => 401, :message => "AWS S3 signature is wrong")
#           render :json => e.to_json, :status => 401
#         end
#       else
#         e = Error.new(:status => 401, :message => "Authtoken has expired")
#         render :json => e.to_json, :status => 401
#       end
#     else
#       e = Error.new(:status => 400, :message => "required parameters are missing")
#       render :json => e.to_json, :status => 400
#     end
#   end
# end

# def delete_photo
#   if request.delete?
#     if params[:photo_id]
#       if @user && @user.authtoken_expiry > Time.now
#         photo = Photo.where(:random_id => params[:photo_id]).first
#
#         if photo && photo.user_id == @user.id
#           s3 = AWS::S3.new
#
#           if s3
#             bucket = s3.buckets[ENV["S3_BUCKET_NAME"]]
#             s3_obj =  bucket.objects[photo.random_id]
#             s3_obj.delete
#
#             photo.destroy
#
#             m = Message.new(:status => 200, :message => "Image deleted")
#             render :json => m.to_json, :status => 200
#           else
#             e = Error.new(:status => 401, :message => "AWS S3 signature is wrong")
#             render :json => e.to_json, :status => 401
#           end
#         else
#           e = Error.new(:status => 401, :message => "Invalid Photo ID or You don't have permission to delete this photo!")
#           render :json => e.to_json, :status => 401
#         end
#       else
#         e = Error.new(:status => 401, :message => "Authtoken has expired. Please get a new token and try again!")
#         render :json => e.to_json, :status => 401
#       end
#     else
#       e = Error.new(:status => 400, :message => "required parameters are missing")
#       render :json => e.to_json, :status => 400
#     end
#   end
# end
#
# def get_photos
#   if @user && @user.authtoken_expiry > Time.now
#     photos = @user.photos
#     render :json => photos.to_json, :status => 200
#   else
#     e = Error.new(:status => 401, :message => "Authtoken has expired. Please get a new token and try again!")
#     render :json => e.to_json, :status => 401
#   end
# end

































