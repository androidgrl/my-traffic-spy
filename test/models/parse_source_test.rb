require './test/test_helper'
class ParseSourceTest < MiniTest::Test

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_it_is_invalid_when_identifier_is_missing
    source = TrafficSpy::ParseSource.new({"rootUrl"=>"http://www.me.com"})
    assert_equal 400, source.status
    assert_equal "Missing information", source.body
  end

  def test_it_is_invalid_when_rootUrl_is_missing
    source = TrafficSpy::ParseSource.new({"identifier"=>"HappyDays"})
    assert_equal 400, source.status
    assert_equal "Missing information", source.body
  end

  def test_it_is_invalid_when_both_fields_are_missing
    source = TrafficSpy::ParseSource.new({})
    assert_equal 400, source.status
    assert_equal "Missing information", source.body
  end

  def test_it_is_invalid_when_identifier_already_exists
    source = TrafficSpy::ParseSource.new ({"identifier" => "JamieK", "rootUrl" => "http://www.jamiek.com"})
    source.source.save
#    assert_equal 403, source.status
    assert_equal "Your account already exists", source.body

  end
end
