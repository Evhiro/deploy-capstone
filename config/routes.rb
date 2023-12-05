Rails.application.routes.draw do

  root "pages#landing"

  get "/admin" => "pages#admin", as: "admin_login", account_type: "admin" 
  get "/student" => "pages#student", as: "student_login", account_type: "student" 
  get "/teacher" => "pages#teacher", as: "teacher_login", account_type: "teacher" 

  #ADMIN
  get "/admin/student" => "pages#student_table", as: "student_table"
  get "/admin/teacher" => "pages#teacher_table", as: "teacher_table"
  get "/admin/accounts" => "pages#admin_accounts", as: "admin_accounts"
  get "/admin/settings" => "pages#admin_settings", as: "admin_settings"

  post "/student/log", to: "pages#create", as:"student_log", account_type: "student"
  post "/teacher/log", to: "pages#create", as:"teacher_log", account_type: "teacher"
  post "/admin/student/log", to: "pages#create", as:"admin_log", account_type: "admin" 


end
