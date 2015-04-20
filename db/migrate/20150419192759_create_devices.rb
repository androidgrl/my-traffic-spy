class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :ip
      t.string :resolution_width
      t.string :resolution_height
    end
  end
end
