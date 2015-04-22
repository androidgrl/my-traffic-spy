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
  end
end
