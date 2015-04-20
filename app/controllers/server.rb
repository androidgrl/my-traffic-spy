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
      body parsed_source.body
      status parsed_source.status
    end

    post '/sources/:identifier/data' do |identifier|
      parsed_request = ParsedRequest.new(params, identifier)
      body parsed_request.body
      status parsed_request.status
    end

    not_found do
      erb :error
    end
  end
end
