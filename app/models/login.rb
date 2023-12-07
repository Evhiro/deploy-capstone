class Login < ApplicationRecord
    has_secure_password

    enum account_type: { admin: 'admin', student: 'student', teacher: 'teacher' }

    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
end
