class AddTimestampColumnToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :ts, :string
    add_column :messages, :thread_ts, :string
    add_column :messages, :slack_parent_user_id, :string
  end
end
