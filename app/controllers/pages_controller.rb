class PagesController < ApplicationController
    def landing
        render "pages/_landing"
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

    #STUDENT PAGES
    def student
        render "pages/Student/_login"
    end
    def student_dashboard
      render "pages/Student/_dashboard"
    end

    #TEACHER PAGES
    def teacher
        render "pages/Teacher/_login"
    end  

        #LOGIN COMMANDS
        def create_student_teacher
            lname = params[:lname]
            fname = params[:fname]
            birth = params[:birth]
            e_address = params[:e_address]
            account_type = params[:account_type]

            email = "#{lname.downcase.gsub(' ', '')}.#{fname.downcase.gsub(' ', '')}"
            password = "#{birth[-4..-1]}-#{birth[0..1]}-#{birth[3..4]}"

            Login.create(email: email, password_digest: BCrypt::Password.create(password), account_type: account_type)

            if account_type == "student"
              Student.create(email: email, e_address: e_address, fname: fname, lname: lname, birth: birth)
            elsif account_type == "teacher"
              Teacher.create(email: email,e_address: e_address, fname: fname, lname: lname, birth: birth)
            end

            redirect_to admin_accounts_path, notice: "Created Successfully"
        end
    
        def account_verify
            user = Login.find_by(email: params[:email])
        
            if user && user.authenticate(params[:password]) && user.account_type == params[:account_type]
              session[:user_id] = user.id
        
              case params[:account_type]
              when "admin"
                redirect_to student_table_path
              when "student"
                redirect_to student_dashboard_path
              when "teacher"
                redirect_to teacher_dashboard_path
              else
                redirect_to root_path
              end
            else
              flash.now[:alert] = "Invalid email or password"
              redirect_to root_path
            end
          end
    
        def destroy
            session[:user_id] = nil
            redirect_to root_path, notice: 'Logged out successfully!'
        end
end
