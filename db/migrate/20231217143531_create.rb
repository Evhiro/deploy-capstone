class Create < ActiveRecord::Migration[7.1]
  def change
    create_table :announcement_boards, id: false do |t|
      t.bigint :announcement_board_id, primary_key: true
      t.string :title
      t.text :content
      t.string :anounced_time
    end
  end
end
