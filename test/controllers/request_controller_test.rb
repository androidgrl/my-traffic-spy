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

  def test_it_returns_403_when_duplicate_request
    source = TrafficSpy::Source.create(identifier: 'poptarts', root_url: "http://www.poptarts.com")
    post '/sources/poptarts/data', 'payload={"ip": "1.2.3.4", "requestedAt": "10:20"}'
    assert_equal 200, last_response.status
    post '/sources/poptarts/data', 'payload={"ip": "1.2.3.4", "requestedAt": "10:20"}'
    assert_equal 403, last_response.status
    assert_equal "Oops...Either you made a Duplicate request, or the Account doesn't exist", last_response.body
  end

  def test_it_returns_403_when_identifier_doesnt_exist
    post '/sources/poptarts/data', 'payload={"ip": "1.2.3.4", "requestedAt": "10:20"}'
    assert_equal 403, last_response.status
    assert_equal "Oops...Either you made a Duplicate request, or the Account doesn't exist", last_response.body
  end

  def test_it_returns_200_when_request_successfully_made
    source = TrafficSpy::Source.create(identifier: 'poptarts', root_url: "http://www.poptarts.com")
    post '/sources/poptarts/data', 'payload={"ip": "1.2.3.4", "requestedAt": "10:20"}'
    assert_equal 200, last_response.status
    assert_equal "Request successfully accepted", last_response.body
  end
end










