module TrafficSpy
  class OperatingSystem < ActiveRecord::Base
    has_many :user_agents
  end
end
