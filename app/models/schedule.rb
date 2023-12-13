class Schedule < ApplicationRecord
  belongs_to :section, primary_key: "section_name", foreign_key: "section_name"
end
