class CreateEditHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :edit_histories do |t|
      t.string :text
      t.references :message
      t.timestamps
    end
  end
end
