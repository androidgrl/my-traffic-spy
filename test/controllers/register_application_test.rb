require './test/test_helper'

class RegisterApplicationTest < MiniTest::Test
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

  def test_it_returns_400_when_identifier_is_missing
    post '/sources', {"rootUrl" => "http://jumpstartlab.com" }

    assert_equal 0, TrafficSpy::Source.count
    assert_equal 400, last_response.status
    assert_equal "Missing information", last_response.body
  end

  def test_it_returns_400_when_rootUrl_is_missing
   post '/sources', {"identifier" => "jamiedearest"}

   assert_equal 0, TrafficSpy::Source.count
   assert_equal 400, last_response.status
   assert_equal "Missing information", last_response.body
  end

  def test_it_returns_400_when_both_identifier_and_rootUrl_are_missing
    post '/sources',{}

    assert_equal 0, TrafficSpy::Source.count
    assert_equal 400, last_response.status
    assert_equal "Missing information", last_response.body
  end

  def test_it_returns_403_when_identifier_already_exists
    post '/sources', {"identifier" => "JamieK", "rootUrl" => "http://www.jamiek.com"}

    assert_equal 1, TrafficSpy::Source.count
    post '/sources', {"identifier" => "JamieK", "rootUrl" => "http://www.jamiek.com"}
    assert_equal 1, TrafficSpy::Source.count
    assert_equal 403, last_response.status
    assert_equal "Your account already exists", last_response.body
  end

  def test_it_returns_200_when_new_identifier_is_created
    post '/sources', {"identifier" => "JamieK", "rootUrl" => "http://www.jamiek.com"}
    post '/sources', {"identifier" => "JamieK", "rootUrl" => "http://www.jamiek.com"}
    post '/sources', {"identifier" => "Lulu", "rootUrl" => "http://www.lulu.com"}

    assert_equal 2, TrafficSpy::Source.count
    assert_equal 200, last_response.status
    assert_equal "Welcome to Traffic Spy!  Your account is successfully registered!", last_response.body
  end
end



















