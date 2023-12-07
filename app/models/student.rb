class Student < ApplicationRecord
    has_one :login, foreign_key: 'email', primary_key: 'email'
end
