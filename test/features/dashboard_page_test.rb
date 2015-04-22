require './test/test_helper'

class DashboardPageTest < MiniTest::Test
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_the_user_sees_an_error_message_when_there_is_no_identifier
    visit '/sources/non_registered_account'
    within('#error') do
      assert page.has_content?("This account is unregistered")
    end
  end

  def test_the_user_sees_the_dashboard_page_when_there_is_an_identifier
    TrafficSpy::Source.create(identifier: "mrs_client", root_url: "http://www.mrs_client.com")
    visit '/sources/mrs_client'
    within('#welcome') do
      assert page.has_content?("Welcome to Traffic Spy!  Here is your account overview:")
    end
  end

  def test_the_user_sees_a_list_of_urls_in_descending_order
    TrafficSpy::Source.create(identifier: "mrs_client", root_url: "http://www.mrs_client.com")
    TrafficSpy::Request.create(url: "http://www.mrs_client/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id)
    TrafficSpy::Request.create(url: "http://www.mrs_client/blog", ip: "2", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id)
    TrafficSpy::Request.create(url: "http://www.mrs_client/blog", ip: "3", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id)


    TrafficSpy::Request.create(url: "http://www.mrs_client/contact", ip: "4", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id)
    TrafficSpy::Request.create(url: "http://www.mrs_client/contact", ip: "5", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id)

    assert_equal 1, TrafficSpy::Source.where(identifier: "mrs_client").count
    assert_equal 1, TrafficSpy::Source.all.count
    assert_equal 5, TrafficSpy::Request.all.count
    visit '/sources/mrs_client'
    within('#urls') do
      assert page.has_content?("Top requested URL's:")
      assert page.has_content?("http://www.mrs_client/blog")
      assert page.has_content?("1:  http://www.mrs_client/blog
                               2: http://www.mrs_client/contact")

    end
  end
end
