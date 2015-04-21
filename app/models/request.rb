module TrafficSpy
  class Request < ActiveRecord::Base
    belongs_to :source
    belongs_to :user_agent

    #def self.urls
      ##i want to get all the requests
      ##from each request i want to count how may times a specific url occurs
      ##then i want to list those urls in descending order
      #Request.all.

    #end
  end
end
