class PagesController < ApplicationController
    before_action :require_login, except: [:landing, :getstarted, :admin, :student, :teacher, :login_check, :account_verify]
    before_action :authenticate_admin!, only: [:student_table, :teacher_table, :admin_announcement, :admin_accounts, :admin_settings, :create_section, :dashboard]
    before_action :authenticate_teacher!, only: [:teacher_dashboard, :teacher_announcement, :teacher_grades, :teacher_schedule, :teacher_settings]
    before_action :authenticate_student!, only: [:student_dashboard, :student_announcement, :student_grades, :student_schedule,:student_settings]
    before_action :not_logged, only: [:landing, :admin, :student, :teacher]

    
    
    class UniqueIntegerGenerator
      def initialize(range)
        @range = range
        @generated_numbers = Set.new
      end
    
      def generate_unique_integer
        begin
          candidate = rand(@range)
        end while @generated_numbers.include?(candidate)
    
        @generated_numbers.add(candidate)
        candidate
      end
    end


    def landing
        render "pages/_landing"
    end
    def getstarted
      render "pages/_start"
    end

    #ADMIN PAGES
    def admin
        render "pages/Admin/_login"
    end
    def student_table
        @students = Student.all
        render "pages/Admin/_tablestudent"
    end
    def teacher_table
        @teachers = Teacher.all
        render "pages/Admin/_tableteacher"
    end
    def admin_accounts
        @user = User.all
        render "pages/Admin/_accounts"
    end
    def admin_settings
        render "pages/Admin/_settings"
    end
    def create_section
      @section = Section.all
      @teacher = Teacher.all
      @student = Student.all
      @subject = Subject.all
      @sched = SubjectTeacherSection.all
      render "pages/Admin/_createsection"
    end
    def dashboard
      @std_count = Student.count
      @teach_count = Teacher.count
      @cls_count = Section.count
      @sub_count = Subject.count
      render "pages/Admin/_dashboard"
    end
    def admin_announcement
      render "pages/Admin/_announcement"
    end

    def view_student
      @stud = Student.all
      render "pages/_student-view"
    end
    def view_teacher
      @stud = Teacher.all
      render "pages/_teacher-view"
    end
    def view_class
      @stud = Section.all
      render "pages/_section-view"
    end
    def view_subject
      @stud = Subject.all
      render "pages/_subject-view"
    end
    #MODAL

    def test
      @teach = Teacher.all
      render "pages/_create-section-modal"
    end
    def add_subteacher
      @section = Section.all
      @teach = Teacher.all
      @sub = Subject.all
      render "pages/_add-subteacher-modal"
    end
    def create_account
      render "pages/_create-account-modal"
    end
    def add_subject
      render "pages/_create-subject-modal"
    end
    def create_sched
      @section = Section.all
      @sub = Subject.all
      @sched = SubjectTeacherSection.all
      render "pages/_schedule-modal"
    end
    def assign_stud
      @stud = Student.all
      @sec = Section.all
      render "pages/_assign-student-modal"
    end
    def announce_modal
      render "pages/_announce-modal"
    end

    #STUDENT PAGES
    def student
        render "pages/Student/_login"
    end
    def student_dashboard
      render "pages/Student/_dashboard"
    end
    def student_settings
      render "pages/Student/_settings"
    end
    def student_announcement
      @announce = AnnouncementBoard.all
      render "pages/Student/_announcement"
    end
    def student_grades
      @student = Student.all
      @schedule = SubjectTeacherSection.all
      @grade = StudentGrade.all
      render "pages/Student/_grades"
    end
    def student_schedule
      @student = Student.all
      @schedule = SubjectTeacherSection.all
      render "pages/Student/_schedule"
    end

    #TEACHER PAGES
    def teacher
        render "pages/Teacher/_login"
    end 
    def teacher_dashboard
      render "pages/Teacher/_dashboard"
    end
    def teacher_settings
      render "pages/Teacher/_settings"
    end
    def teacher_announcement
      @announce = AnnouncementBoard.all
      render "pages/Teacher/_announcement"
    end
    def teacher_grades
      @schedule = SubjectTeacherSection.where(teacher_id: current_user.teacher.teacher_id)
      @advisor = Section.where(teacher_id: current_user.teacher.teacher_id)
      @grade = StudentGrade.where(teacher_id: current_user.teacher.teacher_id)
      @sub = Subject.all
      render "pages/Teacher/_grades"
    end
    def teacher_schedule
      @schedule = SubjectTeacherSection.where(teacher_id: current_user.teacher.teacher_id)
      @advisor = Section.where(teacher_id: current_user.teacher.teacher_id)
      render "pages/Teacher/_schedule"
    end

    def grading_student
      secret_key = Rails.application.credentials.secret_key_base
      obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
      subject = Subject.find_by(subject_name: params[:subject])
      student = Student.find_by(lname: params[:student_name])
      p1 = params[:first_grading]
      p2 = params[:second_grading]
      p3 = params[:third_grading]
      p4 = params[:fourth_grading]

      grading = StudentGrade.find_by(subject_id: subject.subject_id, student_id: student.student_id)

      grading.update(
        first_grading: p1,
        second_grading: p2,
        third_grading: p3,
        fourth_grading: p4
      )
    
    if p1.present? && p2.present? && p3.present? && p4.present?
      ave = (p1.to_f + p2.to_f + p3.to_f + p4.to_f) / 2
      grading.update(
        average: ave
      )
      if ave > 150
        grading.update(
          result: "PASSED"
        )
      else
        grading.update(
          result: "FAILED"
        )
      end

    end
    
      redirect_to teacher_grades_path(email: obfuscated_email)
    end
    
    def remove_info
      secret_key = Rails.application.credentials.secret_key_base
      obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
      remove_acc = params[:id]

      account = User.find_by(user_id: remove_acc)
      student_account = Student.find_by(user_id: remove_acc)
      teacher_account = Teacher.find_by(user_id: remove_acc)
      subject = Subject.find_by(subject_id: remove_acc)
      section = Section.find_by(section_id: remove_acc)

      if student_account.present?
        student_account.destroy
        account.destroy

      elsif teacher_account.present?
        teacher_account.destroy
        account.destroy
      
      elsif subject.present?
        subject.destroy

      elsif section.present?
        section.destroy

      else
        
      end
        redirect_to dashboard_path(email: obfuscated_email)
    end

        def add_section
          secret_key = Rails.application.credentials.secret_key_base
          obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
          grade_lvl = params[:grade_lvl]
          section_name = params[:section_name]
          advisor_name = params[:advisor_name]
          teacher = Teacher.find_by(fname: advisor_name)
          generator = UniqueIntegerGenerator.new(1000..9999)
          section_id = generator.generate_unique_integer 

          Section.create(
            section_id: section_id,
            grade_lvl: grade_lvl,
            section_name: section_name,
            teacher_id: advisor_name
          )

          redirect_to dashboard_path(email: obfuscated_email)

        end

        def add_subject_teacher
          secret_key = Rails.application.credentials.secret_key_base
          obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
          section_name = params[:section_name]
          section = Section.find_by(section_name: section_name)
          
          teacher_name = params[:sub_teacher]
          teacher = Teacher.find_by(teacher_id: teacher_name)

          subject_name = params[:subject_name]
          subject = Subject.find_by(subject_name: subject_name)

          generator = UniqueIntegerGenerator.new(1000..9999)
          id = generator.generate_unique_integer

          sub_sec = SubjectTeacherSection.find_by(subject_id: subject.subject_id, section_id: section.section_id)
          
          if sub_sec.present?
            sub_sec.update(
              teacher_id: teacher.teacher_id
            )
          else
            SubjectTeacherSection.create(
            subject_teacher_sections_id: id,
            section_id: section.section_id,
            subject_id: subject.subject_id,
            teacher_id: teacher.teacher_id
          )
          end

          redirect_to create_section_path(email: obfuscated_email)
        end

        def add_student
          secret_key = Rails.application.credentials.secret_key_base
          obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
          section_name = params[:section_name]
          enrolee = params[:student_name]
          name_parts = enrolee.split
          first_name = name_parts.first
          last_name = name_parts.last
        
          student = Student.find_by(fname: first_name)
        
          section = Section.find_by(section_name: section_name)

          if student && section
            student.update!(section_id: section.id)
          end

          @count_subjects = SubjectTeacherSection.where(section_id: section.id )
          check_student = StudentGrade.find_by(student_id: student.id)

          @count_subjects.each do |t|
            if check_student.present?
              check_student.update!(
                section_id: section.id ,
                subject_id: t.subject_id,
                teacher_id: t.teacher_id
              )
            else
              StudentGrade.create!(
                first_grading: nil,
                second_grading: nil,
                third_grading: nil,
                fourth_grading: nil,
                section_id: section.id,
                subject_id: t.subject_id,
                student_id: student.id,
                average: nil,
                result: nil,
                teacher_id: t.teacher_id
              )
            end
          end

          redirect_to create_section_path(email: obfuscated_email)
        end

        def student_grade_render
          @sec = Section.all
          @stud = Student.all
          @sub = Subject.all
          render "pages/_student-grade-modal"
        end
        def student_grade_addding

        end

        def add_subjects
          secret_key = Rails.application.credentials.secret_key_base
          obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
          name = params[:name]

          subject_exist = Subject.find_by(subject_name: name)
          
          if subject_exist.present?
            
          else
          Subject.create(
            subject_name: name
          )
          end

          redirect_to dashboard_path(email: obfuscated_email)
        end

        def add_schedule
          secret_key = Rails.application.credentials.secret_key_base
          obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
          section = params[:section_name]
          subject = params[:subject_name]
          time_in = params[:time_in]
          time_out = params[:time_out]
          am_pm_one = params[:time_one]
          am_pm_two = params[:time_two]
          week_in_day = params[:week_in_day]
          sub_teacher = Subject.find_by(subject_name: subject)
          section_teacher = Section.find_by(section_name: section)

          schedule = SubjectTeacherSection.find_by(subject_id: sub_teacher.subject_id, section_id: section_teacher.section_id)

          final_time_in = "#{time_in.gsub(' ', '')}#{am_pm_one.upcase}"
          final_time_out = "#{time_out.gsub(' ', '')}#{am_pm_two.upcase}"

          generator = UniqueIntegerGenerator.new(1000..9999)
          id = generator.generate_unique_integer
          
          Schedule.create(
            schedule_id: id,
            time_in: final_time_in,
            time_out: final_time_out,
            day_of_week: week_in_day
          )
          schedule.update(
            schedule_id: id
          )
          

          redirect_to dashboard_path(email: obfuscated_email)
        end

        def add_announce
          secret_key = Rails.application.credentials.secret_key_base
          obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
          title = params[:title]
          content = params[:desc]
          
          announce = AnnouncementBoard.find_by(announcement_board_id: 1)

          #if announce
          announce.update!(
            title: title,
            content: content,
            anounced_time: Time.current
          )
          #end

          redirect_to admin_announcement_path(email: obfuscated_email)
        end

        def create_student_teacher
            lname = params[:lname]
            fname = params[:fname]
            birth = params[:birth]
            e_address = params[:e_address]
            account_type = params[:account_type]
            generator = UniqueIntegerGenerator.new(1000..9999)
            user_id = generator.generate_unique_integer
            id = generator.generate_unique_integer

            email = "#{lname.downcase.gsub(' ', '')}.#{fname.downcase.gsub(' ', '')}"
            password = birth

            hashed_password = BCrypt::Password.create(password)

            User.create(user_id: user_id, email: email, password_digest: hashed_password, account_type: account_type.downcase)


            
            if account_type == "student"
              Student.create(student_id: id, e_address: e_address, fname: fname, lname: lname, bday: birth, age: 1 , user_id: user_id)
            elsif account_type == "teacher"
              Teacher.create(teacher_id: id, e_address: e_address, fname: fname, lname: lname, bday: birth, age: 1 , user_id: user_id)
            end

            secret_key = Rails.application.credentials.secret_key_base
            obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
            redirect_to dashboard_path(email: obfuscated_email), notice: "Created Successfully"
        end
    
        def account_verify
            user = User.find_by(email: params[:email])
        
            if user && user.authenticate(params[:password]) && user.account_type == params[:account_type]
              session[:user_id] = user.user_id
              secret_key = Rails.application.credentials.secret_key_base
              obfuscated_email = Digest::SHA256.hexdigest("#{user.email}-#{secret_key}")
        
              case params[:account_type]
              when "admin"
                redirect_to dashboard_path(email: obfuscated_email)
              when "student"
                redirect_to student_dashboard_path(email: obfuscated_email)
              when "teacher"
                redirect_to teacher_dashboard_path(email: obfuscated_email)
              else
                flash[:alert] = "Invalid email or password"
                redirect_to landing_path
              end
            else
              flash[:alert] = "Invalid email or password"
              redirect_to landing_path
            end
          end

          def not_logged
            if logged_in?
              secret_key = Rails.application.credentials.secret_key_base
              obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
              case current_user.account_type
              when "admin"
                redirect_to dashboard_path(email: obfuscated_email)
              when "student"
                redirect_to student_dashboard_path(email: obfuscated_email)
              when "teacher"
                redirect_to teacher_dashboard_path(email: obfuscated_email)
              end
            end
          end

          def login_check
            if logged_in?
              secret_key = Rails.application.credentials.secret_key_base
              obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
              case current_user.account_type
              when "admin"
                redirect_to dashboard_path(email: obfuscated_email)
              when "student"
                redirect_to student_dashboard_path(email: obfuscated_email)
              when "teacher"
                redirect_to teacher_dashboard_path(email: obfuscated_email)
              end
            elsif !logged_in?
              case params[:account_type]
              when "admin"
                redirect_to admin_login_path
              when "student"
                redirect_to student_login_path
              when "teacher"
                redirect_to teacher_login_path
              else
                redirect_to landing_path
              end
            end
          end
        
        def change_password
          user = current_user
          if user && user.authenticate(params[:password])
            new_password = params[:new_password]
            hashed_password = BCrypt::Password.create(new_password)

            user.update!(password_digest: hashed_password)
            redirect_to sign_out_path
          else
            redirect_to root_path
          end
        end  

        def sign_out
          session.clear
          redirect_to landing_path, notice: 'Logged out successfully!'
        end
        
                
      helper_method :current_user, :current_person
      private
      
      def current_user
        @current_user ||= User.find_by(user_id: session[:user_id]) if session[:user_id]
      end
      
      def current_person
        if current_user
          @current_person ||= current_user.student || current_user.teacher
        end
      end
      
      def logged_in?
        !current_user.nil?
      end
      
      def require_login
        unless logged_in?
          flash[:alert] = 'You must be logged in to access this page.'
          redirect_to landing_path
        end
      end

      def authenticate_admin!
        redirect_to account_check_path unless current_user && current_user.account_type == 'admin'
      end
    
      def authenticate_teacher!
        redirect_to account_check_path unless current_user && current_user.account_type == 'teacher'
      end
    
      def authenticate_student!
        redirect_to account_check_path unless current_user && current_user.account_type == 'student'
      end
      
end
