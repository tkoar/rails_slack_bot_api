class CreateChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :channels do |t|
      t.string :name
      t.string :slack_channel_id
      t.string :last_message_timestamp
      t.timestamps
    end
  end
end
