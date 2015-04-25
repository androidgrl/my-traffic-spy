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

      browser_names = browser_ids.map {|id| Browser.find(id).name }
    end

    def self.operating_systems(identifier)
      request_objects = Request.where(source_id: Source.find_by(identifier: identifier).id)
      user_agent_ids = request_objects.all.map {|request_object| request_object.user_agent_id }
      user_agent_objects = user_agent_ids.map {|id| UserAgent.find(id)}
      operating_system_ids = user_agent_objects.map {|user_agent| user_agent.operating_system_id }

      operating_system_names = operating_system_ids.map {|id| OperatingSystem.find(id).name }
    end

    def self.screen_resolutions(identifier)
      request_objects = Request.where(source_id: Source.find_by(identifier: identifier).id)
      widths = request_objects.map {|ro| ro.resolution_width}
      heights = request_objects.map {|ro| ro.resolution_height}
      widths_and_heights = widths.zip(heights)
    end

    def self.avg_response_times(identifier)
      request_objects = Request.where(source_id: Source.find_by(identifier: identifier).id)
      urls = request_objects.map {|request| request.url}.uniq
      requests_by_url = urls.map {|url| Request.where(url: url)}
      response_times = requests_by_url.map do |array|
        array.map {|request| request.responded_in}
      end
      average_times = response_times.map do |array|
        array.reduce(0, :+) / array.length
      end
      urls_and_times = urls.zip(average_times)
    end
  end
end






