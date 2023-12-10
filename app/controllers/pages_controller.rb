class PagesController < ApplicationController
    before_action :require_login, except: [:landing, :getstarted, :admin, :student, :teacher, :login_check, :account_verify]
    before_action :authenticate_admin!, only: [:student_table, :teacher_table, :admin_announcement, :admin_accounts, :admin_settings]
    before_action :authenticate_teacher!, only: [:teacher_dashboard, :teacher_announcement, :teacher_grades, :teacher_schedule, :teacher_settings]
    before_action :authenticate_student!, only: [:student_dashboard, :student_announcement, :student_grades, :student_schedule,:student_settings]

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
        @logins = Login.all
        render "pages/Admin/_accounts"
    end
    def admin_settings
        render "pages/Admin/_settings"
    end
    def create_section
      render "pages/Admin/_createsection"
    end
    def view_section
      render "pages/Admin/_viewsection"
    end
    def admin_announcement
      render "pages/Admin/_announcement"
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
      render "pages/Student/_announcement"
    end
    def student_grades
      render "pages/Student/_grades"
    end
    def student_schedule
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
      render "pages/Teacher/_announcement"
    end
    def teacher_grades
      render "pages/Teacher/_grades"
    end
    def teacher_schedule
      render "pages/Teacher/_schedule"
    end

        #LOGIN COMMANDS
        def create_student_teacher
            lname = params[:lname]
            fname = params[:fname]
            birth = params[:birth]
            e_address = params[:e_address]
            account_type = params[:account_type]

            email = "#{lname.downcase.gsub(' ', '')}.#{fname.downcase.gsub(' ', '')}"
            password = birth

            hashed_password = BCrypt::Password.create(password)

            Login.create(email: email, password_digest: hashed_password, account_type: account_type.downcase)

            if account_type == "student"
              Student.create(email: email, e_address: e_address, fname: fname, lname: lname, birth: birth)
            elsif account_type == "teacher"
              Teacher.create(email: email,e_address: e_address, fname: fname, lname: lname, birth: birth)
            end

            secret_key = Rails.application.credentials.secret_key_base
            obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
            redirect_to admin_accounts_path(email: obfuscated_email), notice: "Created Successfully"
        end
    
        def account_verify
            user = Login.find_by(email: params[:email])
        
            if user && user.authenticate(params[:password]) && user.account_type == params[:account_type]
              session[:user_id] = user.id
              secret_key = Rails.application.credentials.secret_key_base
              obfuscated_email = Digest::SHA256.hexdigest("#{user.email}-#{secret_key}")
        
              case params[:account_type]
              when "admin"
                redirect_to student_table_path(email: obfuscated_email)
              when "student"
                redirect_to student_dashboard_path(email: obfuscated_email)
              when "teacher"
                redirect_to teacher_dashboard_path(email: obfuscated_email)
              else
                redirect_to landing_path
              end
            else
              flash.now[:alert] = "Invalid email or password"
              redirect_to landing_path
            end
          end
        
          def login_check
            if logged_in?
              secret_key = Rails.application.credentials.secret_key_base
              obfuscated_email = Digest::SHA256.hexdigest("#{current_user.email}-#{secret_key}")
              case current_user.account_type
              when "admin"
                redirect_to student_table_path(email: obfuscated_email)
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
        
        #NOT WORKING
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
        @current_user ||= Login.find_by(id: session[:user_id]) if session[:user_id]
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
