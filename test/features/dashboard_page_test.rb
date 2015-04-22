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
      assert page.has_content?("1:  http://www.mrs_client/blog
                               2: http://www.mrs_client/contact")

    end
  end

  def test_the_user_sees_browser_breakdown_for_all_requests
    skip
    TrafficSpy::Source.create(identifier: "mrs_client", root_url: "http://www.mrs_client.com")
    TrafficSpy::Browser.create(name: "Boogle")
    TrafficSpy::OperatingSystem.create(name: "MacnCheese")
    user_agent = TrafficSpy::UserAgent.create(browser_id: TrafficSpy::Browser.find_by(name: "Boogle").id, operating_system_id: TrafficSpy::OperatingSystem.find_by(name: "MacnCheese").id)
    TrafficSpy::Request.create(url: "http://www.mrs_client/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id)
    TrafficSpy::Request.create(url: "http://www.mrs_client/blog", ip: "2", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id)
    TrafficSpy::Request.create(url: "http://www.mrs_client/blog", ip: "3", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id)


    visit '/sources/mrs_client'
    within('#browsers') do
      assert page.has_content?("Browsers Used:")
      assert page.has_content?("Boogle")
    end
  end
end
