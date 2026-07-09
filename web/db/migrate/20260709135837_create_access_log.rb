class CreateAccessLog < ActiveRecord::Migration[8.1]
  def change
    create_table :access_log do |t|
      t.string :actor_id, null: false
      t.string :subject_user_id, null: false
      t.string :field_class, null: false
      t.datetime :looked_at, null: false
      t.timestamps
    end

    add_index :access_log, :actor_id
    add_index :access_log, :subject_user_id
  end
end
