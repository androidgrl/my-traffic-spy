require './test/test_helper'
class ParseSourceTest < MiniTest::Test

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_it_is_invalid_when_identifier_is_missing
    parse_source = TrafficSpy::ParseSource.new({"rootUrl"=>"http://www.me.com"})
    assert_equal 400, parse_source.status
    assert_equal "Missing information", parse_source.body
  end

  def test_it_is_invalid_when_rootUrl_is_missing
    parse_source = TrafficSpy::ParseSource.new({"identifier"=>"HappyDays"})
    assert_equal 400, parse_source.status
    assert_equal "Missing information", parse_source.body
  end

  def test_it_is_invalid_when_both_fields_are_missing
    parse_source = TrafficSpy::ParseSource.new({})
    assert_equal 400, parse_source.status
    assert_equal "Missing information", parse_source.body
  end

  def test_it_is_invalid_when_identifier_already_exists
    parse_source = TrafficSpy::ParseSource.new ({"identifier" => "JamieK", "rootUrl" => "http://www.jamiek.com"})
    parse_source = TrafficSpy::ParseSource.new ({"identifier" => "JamieK", "rootUrl" => "http://www.jamiek.com"})
#    assert_equal 403, parse_source.status
    assert_equal "Your account already exists", parse_source.body

  end
end
