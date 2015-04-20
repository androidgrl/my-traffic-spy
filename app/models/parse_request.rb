module TrafficSpy
  class ParsedRequest
    attr_reader :request

    def initialize(params, identifier)
      if params[:payload].present? == false
        @data = {}
      else
        @data = JSON.parse(params[:payload])
      end
      @identifier = identifier
    end

    def status
      if @data == {}
        400
      elsif duplicate_request? || no_existing_identifier?
        403
      else
       @request = Request.create(
        url: @data["url"],
        requested_at: @data["requestedAt"],
        responded_in: @data["respondedIn"],
        ip: @data["ip"]
      )
        200
      end
    end

    def body
      if status == 400
        "Missing information"
      elsif status == 403
        "Oops...Either you made a Duplicate request, or the Account doesn't exist"
      else
        "Request successfully accepted"
      end
    end

    def duplicate_request?
      Request.find_by(requested_at: @data["requestedAt"], ip: @data["ip"]) != nil
    end

    def no_existing_identifier?
      Source.find_by(identifier: @identifier).nil?
    end
  end
end










