class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :slack_id
      t.string :real_name
      t.string :team_id
      t.string :tz
      t.string :tz_label
      t.string :tz_offset
      t.timestamps
    end
  end
end
