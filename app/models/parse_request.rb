module TrafficSpy
  class ParsedRequest
    #attr_reader :request

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
      elsif duplicate_request?
        403
      elsif no_existing_identifier?
        403
      else
        200
      end
    end

    def body
      if status == 400
        "Missing information"
      elsif status == 403
        "Oops...Either you made a Duplicate request, or the Account doesn't exist"
      else
        Request.create(
          url: @data["url"],
          requested_at: @data["requestedAt"],
          responded_in: @data["respondedIn"],
          referred_by: @data["referredBy"],
          request_type: @data["requestType"],
          parameters: @data["parameters"],
          event_name: @data["eventName"],
          user_agent_id: UserAgent.find_or_create_by(
            browser: find_or_create_browser,
            operating_system: find_or_create_operating_system
          ).id,
          resolution_width: @data["resolutionWidth"],
          resolution_height: @data["resolutionHeight"],
          ip: @data["ip"],
          source_id: Source.find_by(identifier: @identifier).id,
          created_at: @data["created_at"],
          updated_at: @data["updated_at"]
        )
        "Request successfully accepted"
      end
    end

    def find_or_create_browser
      Browser.find_or_create_by(name: parse_browser_name)
    end

    def find_or_create_operating_system
      OperatingSystem.find_or_create_by(name: parse_operating_system_name)
    end

    def parse_browser_name
      json_string = @data["userAgent"]
      user_agent = ::UserAgent.parse(json_string)
      user_agent.browser
    end

    def parse_operating_system_name
      json_string = @data["userAgent"]
      user_agent = ::UserAgent.parse(json_string)
      user_agent.platform
    end

    def duplicate_request?
      Request.where(requested_at: @data["requestedAt"], ip: @data["ip"]).count > 0
    end

    def no_existing_identifier?
      Source.find_by(identifier: @identifier).nil?
    end
  end
end
