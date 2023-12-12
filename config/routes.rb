Rails.application.routes.draw do
  #FIX THIS
  patch '/change_password', to: "pages#change_password", as: "change_password"


  #root "pages#getstarted"
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
  get "/admin/:email/create-section" => "pages#create_section", as: "create_section"
  get "/admin/:email/view-section" => "pages#view_section", as: "view_section"
  get "/admin/:email/announcement" => "pages#admin_announcement", as: "admin_announcement"

  #STUDENT
  get "/student/:email/dashboard" => "pages#student_dashboard", as: "student_dashboard"
  get "/student/:email/settings" => "pages#student_settings", as: "student_settings"
  get "/student/:email/announcement" => "pages#student_announcement", as: "student_announcement"
  get "/student/:email/grades" => "pages#student_grades", as: "student_grades"
  get "/student/:email/schedule" => "pages#student_schedule", as: "student_schedule"

  #TEACHER
  get "/teacher/:email/dashboard" => "pages#teacher_dashboard", as: "teacher_dashboard"
  get "/teacher/:email/settings" => "pages#teacher_settings", as: "teacher_settings"
  get "/teacher/:email/announcement" => "pages#teacher_announcement", as: "teacher_announcement"
  get "/steacher/:email/grades" => "pages#teacher_grades", as: "teacher_grades"
  get "/teacher/:email/schedule" => "pages#teacher_schedule", as: "teacher_schedule"

  post "/student/log", to: "pages#account_verify", as:"student_log", account_type: "student"
  post "/teacher/log", to: "pages#account_verify", as:"teacher_log", account_type: "teacher"
  post "/admin/log", to: "pages#account_verify", as:"admin_log", account_type: "admin"
  post "/admin/create/info", to: "pages#create_student_teacher", as: "admin_insert_info"
  post "/admin/create/section", to: "pages#add_section", as:"add_section"
  post "/admin/assign/teacher", to: "pages#add_subject_teacher", as: "add_subject_teacher"
  post "/admin/assign/student", to: "pages#add_student", as: "add_student"
  post "/admin/create/schedules",to: "pages#add_schedule", as: "add_schedule"
  root "pages#login_check", as: "account_check"


end
