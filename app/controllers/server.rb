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

    post '/sources/:identifier/data' do
     request = Request.new(JSON.parse(params[:payload]), params[:identifier])
     body request.body
     status request.status
    end

    not_found do
      erb :error
    end
  end
end
