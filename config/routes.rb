Rails.application.routes.draw do
  delete '/remove_info', to: "pages#remove_info", as: "remove"
  post 'teacher/student-grading', to: "pages#grading_student", as: "student_grading"
  patch '/change_password', to: "pages#change_password", as: "change_password"

  #root "pages#getstarted"
  get "/GTNHS", to: "pages#landing", as: "landing"
  match '/sign_out', to: 'pages#sign_out',via: [:delete, :get], as: 'sign_out'

  get "/section" => "pages#test", as: "testing"
  get "/view-student" => "pages#view_student", as:"view_student"
  get "/view-teacher" => "pages#view_teacher", as:"view_teacher"
  get "/view-class" => "pages#view_class", as:"view_class"
  get "/view-subject" => "pages#view_subject", as:"view_subject"

  get "/admin" => "pages#admin", as: "admin_login", account_type: "admin" 
  get "/student" => "pages#student", as: "student_login", account_type: "student" 
  get "/teacher" => "pages#teacher", as: "teacher_login", account_type: "teacher" 

  #ADMIN
  get "/admin/:email/student" => "pages#student_table", as: "student_table"
  get "/admin/:email/teacher" => "pages#teacher_table", as: "teacher_table"
  get "/admin/:email/accounts" => "pages#admin_accounts", as: "admin_accounts"
  get "/admin/:email/settings" => "pages#admin_settings", as: "admin_settings"
  get "/admin/:email/create-section" => "pages#create_section", as: "create_section"
  get "/admin/:email/dashboard" => "pages#dashboard", as: "dashboard"
  get "/admin/:email/announcement" => "pages#admin_announcement", as: "admin_announcement"
  #MODAL
  get "admin/:email/create-account" => "pages#create_account", as: "create_account"
  get "admin/:email/add-subject" => "pages#add_subject", as: "add_subject"
  get "admin/:email/add-subteacher" => "pages#add_subteacher", as: "add_subteacher"
  get "admin/:email/add-schedule" => "pages#create_sched", as: "schedule"
  get "admin/:email/assign-stud" => "pages#assign_stud", as: "assign_stud"
  get "admin/:email/announce-modal" => "pages#announce_modal", as: "announce_modal"
  get "admin/:email/student_grade_render" => "pages#student_grade_render", as: "student_grade_render"
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

  
  post "/admin/add/student_grade_addding", to: "pages#student_grade_addding", as: "student_grade_addding"
  post "/student/log", to: "pages#account_verify", as:"student_log", account_type: "student"
  post "/teacher/log", to: "pages#account_verify", as:"teacher_log", account_type: "teacher"
  post "/admin/log", to: "pages#account_verify", as:"admin_log", account_type: "admin"
  post "/admin/:email/create-info", to: "pages#create_student_teacher", as: "admin_insert_info"
  post "/admin/create/section", to: "pages#add_section", as:"add_section"
  post "/admin/assign/teacher", to: "pages#add_subject_teacher", as: "add_subject_teacher"
  post "/admin/add-subject", to: "pages#add_subjects", as: "add_subjects"
  post "/admin/assign/student", to: "pages#add_student", as: "add_student"
  post "/admin/create/schedules",to: "pages#add_schedule", as: "add_schedule"
  post "/admin/add/announcement", to: "pages#add_announce", as: "add_announce"
  root "pages#login_check", as: "account_check"


end
