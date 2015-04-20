require './test/test_helper'

class RequestControllerTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_it_returns_400_when_the_payload_is_empty_hash
    source = TrafficSpy::Source.create(identifier: 'poptarts', root_url: "http://www.poptarts.com")
    post '/sources/poptarts/data', 'payload={}'
    assert_equal 400, last_response.status
    assert_equal "Missing information", last_response.body
  end

  def test_it_returns_400_when_payload_is_missing
    source = TrafficSpy::Source.create(identifier: 'poptarts', root_url: "http://www.poptarts.com")
    post '/sources/poptarts/data'
    assert_equal 400, last_response.status
    assert_equal "Missing information", last_response.body

  end

  def test_it_returns_403_when_payload_already_exists
    skip
    source = TrafficSpy::Source.create(identifier: 'poptarts')
    post '/sources/poptarts/data', 'payload={"url": "jumpstart", "requested_at": "10:20"}', 'poptarts'
    post '/sources/poptarts/data', 'payload={"url": "jumpstart", "requested_at": "10:20"}', 'poptarts'
    assert_equal 403, last_response.status
    assert_equal "Duplicate request", last_response.body
  end
end










