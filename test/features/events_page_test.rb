require './test/test_helper'

class EventsPageTest < MiniTest::Test
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def create_requests
    TrafficSpy::Source.create(identifier: "mrs_client", root_url: "http://www.mrs_client.com")

    TrafficSpy::Browser.create(name: "chrome")
    TrafficSpy::OperatingSystem.create(name: "mac")

    user_agent = TrafficSpy::UserAgent.create(browser_id: TrafficSpy::Browser.find_by(name: "chrome").id, operating_system_id: TrafficSpy::OperatingSystem.find_by(name: "mac").id)

    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 31, resolution_width: 600, resolution_height: 800, event_name: "SocialLogin")
    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 32, resolution_width: 600, resolution_height: 800, event_name: "SocialLogin")
    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 33, resolution_width: 600, resolution_height: 800, event_name: "SocialLogin")

    TrafficSpy::Request.create(url: "http://www.mrs_client.com/contact", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 30, resolution_width: 600, resolution_height: 800, event_name: "ContactEmail")
  end

  def test_the_user_sees_links_to_individal_events_ranked_in_descending_order_by_amount_received
    skip
    create_requests

    visit '/sources/mrs_client/events'
    within('#index') do
      assert page.has_content?("Events Index Ranked by most Popular:
                               1.  SocialLogin
                               2.  ContactEmail")
    end
  end

end
