module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    get '/sources' do
      "Client name: #{Source.last.identifier} , Website to monitor:  #{Source.last.root_url}"
    end

    post '/sources' do
      parsed_source = ParseSource.new(params)
      status parsed_source.status
      body parsed_source.body
    end

    post '/sources/:identifier/data' do |identifier|
      parsed_request = ParsedRequest.new(params, identifier)
      status parsed_request.status
      body parsed_request.body
    end

    get '/sources/:identifier' do |identifier|
      if Source.where(identifier: identifier).count > 0
        urls = Request.urls(identifier)
        browsers = Request.browsers(identifier)
        operating_systems = Request.operating_systems(identifier)
        screen_resolutions = Request.screen_resolutions(identifier)
        avg_response_times = Request.avg_response_times(identifier)
        erb :dashboard, :locals => {:urls => urls,
                                    :browsers => browsers,
                                    :operating_systems => operating_systems,
                                    :screen_resolutions => screen_resolutions,
                                    :avg_response_times => avg_response_times,
                                    :identifier => identifier
                                    }
      else
        erb :error
      end
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      root_url = Source.find_by(identifier: identifier).root_url
      if Request.where(url: "#{root_url}/#{relative_path}").count > 0
        longest_response_time = Request.longest_response_time(identifier, relative_path)
        shortest_response_time = Request.shortest_response_time(identifier, relative_path)
        average_response_time = Request.average_response_time(identifier, relative_path)
        http_verbs = Request.http_verbs(identifier, relative_path)
        popular_referrers = Request.popular_referrers(identifier, relative_path)
        popular_user_agents = Request.popular_user_agents(identifier, relative_path)
        erb :url_stats, :locals => {:root_url => root_url,
                                    :identifier => identifier,
                                    :relative_path => relative_path,
                                    :longest_response_time => longest_response_time,
                                    :shortest_response_time => shortest_response_time,
                                    :average_response_time => average_response_time,
                                    :http_verbs => http_verbs,
                                    :popular_referrers => popular_referrers,
                                    :popular_user_agents => popular_user_agents
                                    }
      else
        erb :error
      end
    end

    not_found do
      erb :error
    end
  end
end
