module TrafficSpy
  class ParseSource
    attr_reader :source

    def initialize(params)
      @source = Source.create(
        identifier: params[:identifier],
        root_url: params[:rootUrl]
      )
    end

    def status
      if @source[:identifier].nil? || @source[:root_url].nil?
        400
      elsif @source.valid?
        200
      else
        403
      end
    end

    def body
      case status
      when 400
        "Missing information"
      when 403
        "Your account already exists"
      when 200
        "Welcome to Traffic Spy!  Your account is successfully registered!"
      end
    end
  end
end
