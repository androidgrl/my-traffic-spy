module TrafficSpy
  class ParsedRequest
    attr_reader :request

    def initialize(params, identifier)
      data = JSON.parse(params[:payload])
      @request = Request.create(
        url: data["url"]
        )
      @identifier = identifier
    end

    def status
      400
    end

    def body
      "Missing information"
    end
  end
end
