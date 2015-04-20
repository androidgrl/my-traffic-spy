module TrafficSpy
  class Browser < ActiveRecord::Base
    has_many :user_agents
  end
end
