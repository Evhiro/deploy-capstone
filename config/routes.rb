Rails.application.routes.draw do
  #FIX THIS
  patch '/change_password', to: "pages#change_password", as: "change_password"


  root "pages#getstarted"
  get "/GTNHS", to: "pages#landing", as: "landing"
  match '/sign_out', to: 'pages#sign_out',via: [:delete, :get], as: 'sign_out'


  get "/admin" => "pages#admin", as: "admin_login", account_type: "admin" 
  get "/student" => "pages#student", as: "student_login", account_type: "student" 
  get "/teacher" => "pages#teacher", as: "teacher_login", account_type: "teacher" 

  #ADMIN
  get "/admin/:email/student" => "pages#student_table", as: "student_table"
  get "/admin/:email/teacher" => "pages#teacher_table", as: "teacher_table"
  get "/admin/:email/accounts" => "pages#admin_accounts", as: "admin_accounts"
  get "/admin/:email/settings" => "pages#admin_settings", as: "admin_settings"

  #STUDENT
  get "/student/:email/dashboard" => "pages#student_dashboard", as: "student_dashboard"
  get "/student/:email/settings" => "pages#student_settings", as: "student_settings"
  get "/student/:email/announcement" => "pages#student_announcement", as: "student_announcement"
  get "student/:email/grades" => "pages#student_grades", as: "student_grades"
  get "/student/:email/schedule" => "pages#student_schedule", as: "student_schedule"

  post "/student/log", to: "pages#account_verify", as:"student_log", account_type: "student"
  post "/teacher/log", to: "pages#account_verify", as:"teacher_log", account_type: "teacher"
  post "/admin/log", to: "pages#account_verify", as:"admin_log", account_type: "admin"
  post "/admin/create/info", to: "pages#create_student_teacher", as: "admin_insert_info"
  get "/checking", to: "pages#login_check", as: "account_check"


end
