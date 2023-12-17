class Add < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules, id: false do |t|
      t.bigint :schedule_id, primary_key: true
      t.string :time_in
      t.string :time_out
      t.string :day_of_week
    end
    
    add_reference :subject_teacher_sections, :schedule, foreign_key: {to_table: :schedules, primary_key: :schedule_id , type: :bigint}
  end
end
