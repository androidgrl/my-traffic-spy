class CreatePayloads < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :url
      t.string :requested_at
      t.integer :responded_in
      t.string :referred_by
      t.string :request_type
      t.string :parameters, array: true
      t.string :event_name
      t.integer :user_agent_id
      t.string :resolution_width
      t.string :resolution_height
      t.string :ip
      t.integer :source_id
      t.timestamps null: false
    end
  end
end
