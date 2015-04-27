require './test/test_helper'

class EventShowPageTest < MiniTest::Test
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

    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 31, resolution_width: 600, resolution_height: 800, event_name: "SocialLogin", requested_at: "2013-02-16 21:38:28 -0700")
    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 32, resolution_width: 600, resolution_height: 800, event_name: "SocialLogin", requested_at: "2013-02-16 22:38:28 -0700")
    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 33, resolution_width: 600, resolution_height: 800, event_name: "SocialLogin", requested_at: "2013-02-16 22:38:28 -0700")

    TrafficSpy::Request.create(url: "http://www.mrs_client.com/contact", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 30, resolution_width: 600, resolution_height: 800, event_name: "ContactEmail", requested_at: "2013-02-16 01:38:28 -0700")
  end

  def test_events_are_listed_by_when_they_occured
    create_requests

    visit "/sources/mrs_client/events/SocialLogin"
    within("#times") do
      assert page.has_content?("Event Requests listed by Time for SocialLogin:
                               Hour 21: 1 requests
                               Hour 22: 2 requests
                               ")
    end

    visit "/sources/mrs_client/events/ContactEmail"
    within("#times") do
      assert page.has_content?("Event Requests listed by Time for ContactEmail:
                               Hour 01: 1 requests
                               ")
    end
  end
end










