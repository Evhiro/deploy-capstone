class PagesController < ApplicationController
    before_action :require_login, except: [:landing, :getstarted, :admin, :student, :teacher, :login_check, :account_verify]
    

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
        render "pages/Admin/_tablestudent"
    end
    def teacher_table
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
      
          if user.password == user.params[:password]
            redirect_to landing_path
            if 
              redirect_to sign_out_path
            else

            end
          else

          end
        end  

        def sign_out
          session[:user_id] = nil
          reset_session
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
      
end
