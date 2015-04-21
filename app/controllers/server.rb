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
       # @urls = Request.urls
        erb :dashboard
      else
        erb :error
      end
    end

    not_found do
      erb :error
    end
  end
end
