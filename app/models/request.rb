module TrafficSpy
  class Request < ActiveRecord::Base
    belongs_to :source
    belongs_to :user_agent

    #def initialize(payload, identifier)
      #@request = Request.create(url:  payload[:url],  identifier: identifier)
      #@payload = payload
      #@identifier = identifier
    #end

    #def body
      #if status == 400
        #"Missing information"
      #end
    #end

    #def status
      #if @payload.nil? || @payload=={}
        #400
      #elsif url_results.count > 0 && requested_at_results > 0
        #403
      #end
    #end

    #def url_results
      #results = []
      #results << Request.find_by(url: @payload[:url])
    #end

    #def requested_at_results
      #results = []
      #results << Request.find_by(requested_at: @payload[:requested_at])
    #end
  end
end
