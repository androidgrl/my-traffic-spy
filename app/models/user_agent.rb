module TrafficSpy
  class UserAgent < ActiveRecord::Base
    belongs_to :browser
    belongs_to :operating_system
    has_many :requests
  end
end
