class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :text
      t.string :client_msg_id
      t.string :user_slack_id
      t.string :user_name
      t.references :channel
      t.references :user
      t.timestamps
    end
  end
end
