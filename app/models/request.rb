module TrafficSpy
  class Request < ActiveRecord::Base
    belongs_to :source
    belongs_to :user_agent

    def self.urls(identifier)

      request_objects = Request.where(source_id: Source.find_by(identifier: identifier).id)
      raw_urls = request_objects.all.map do |request|
        request.url
      end

      hash_with_url_frequency_as_values = raw_urls.each_with_object(Hash.new(0)) do |element, hash|
        hash[element] += 1
      end

      sorted_hash = hash_with_url_frequency_as_values.sort_by {|key, value| value}.reverse

      ranked_urls = sorted_hash.map {|pair| pair.first}
    end

    def self.browsers(identifier)

      request_objects = Request.where(source_id: Source.find_by(identifier: identifier).id)
      user_agent_ids = request_objects.all.map {|request_object| request_object.user_agent_id }
      user_agent_objects = user_agent_ids.map {|id| UserAgent.find(id)}
      browser_ids = user_agent_objects.map {|user_agent| user_agent.browser_id }

      browsers = browser_ids.map {|id| Browser.find(id) }
    end
  end
end
