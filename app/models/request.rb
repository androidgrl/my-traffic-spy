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
      sorted_urls_and_times = urls_and_times.sort_by {|x,y| y}.reverse
    end


    def self.sorted_times(identifier, relative_path)
      root_url = Source.find_by(identifier: identifier).root_url
      request_objects = Request.where(url: "#{root_url}/#{relative_path}")
      sorted_times = request_objects.map { |request| request.responded_in }.sort
    end

    def self.longest_response_time(identifier, relative_path)
      self.sorted_times(identifier, relative_path).last
    end

    def self.shortest_response_time(identifier, relative_path)
      self.sorted_times(identifier, relative_path).first
    end

    def self.average_response_time(identifier, relative_path)
      array = self.sorted_times(identifier, relative_path)
      average = array.reduce(0, :+) / array.length
    end

    def self.http_verbs(identifier, relative_path)
      root_url = Source.find_by(identifier: identifier).root_url
      request_objects = Request.where(url: "#{root_url}/#{relative_path}")
      verbs = request_objects.map { |request| request.request_type }.uniq
    end

    def self.popular_referrers(identifier, relative_path)
      root_url = Source.find_by(identifier: identifier).root_url
      request_objects = Request.where(url: "#{root_url}/#{relative_path}")
      referrers = request_objects.map {|request| request.referred_by}
      hash_with_frequency_as_values = referrers.each_with_object(Hash.new(0)) do |referrer, hash|
        hash[referrer] += 1
      end

      sorted_hash = hash_with_frequency_as_values.sort_by {|key, value| value}.reverse

      ranked_referrers = sorted_hash.map {|pair| pair.first}
    end

    def self.popular_user_agents(identifier, relative_path)
      #from the request objects, map the user_agent_ids
      #rank by frequency
      #then map the browser and os for each
      root_url = Source.find_by(identifier: identifier).root_url
      request_objects = Request.where(url: "#{root_url}/#{relative_path}")
      user_agent_ids = request_objects.map {|request| request.user_agent_id}
      hash_with_frequency_as_values = user_agent_ids.each_with_object(Hash.new(0)) do |id, hash|
        hash[id] += 1
      end

      sorted_hash = hash_with_frequency_as_values.sort_by {|key, value| value}.reverse

      ranked_user_agent_ids = sorted_hash.map {|pair| pair.first}
      ranked_user_agents = ranked_user_agent_ids.map {|id| UserAgent.find(id)}
      ranked_info = ranked_user_agents.map {|agent| "#{Browser.find(agent.browser_id).name}, #{OperatingSystem.find(agent.operating_system_id).name}"}
    end
  end
end






