class User < ApplicationRecord
    has_secure_password
    has_one :student, foreign_key: 'user_id'
    has_one :teacher, foreign_key: 'user_id'
    has_one :admin, foreign_key: 'user_id'

end
