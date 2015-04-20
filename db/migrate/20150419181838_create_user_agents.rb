class CreateUserAgents < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.integer :browser_id
      t.integer :operating_system_id
    end
  end
end
