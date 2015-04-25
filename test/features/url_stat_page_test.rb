require './test/test_helper'

class UrlStatPageTest < MiniTest::Test
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

    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 31, resolution_width: 600, resolution_height: 800)
    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 32, resolution_width: 600, resolution_height: 800)
    TrafficSpy::Request.create(url: "http://www.mrs_client.com/blog", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 33, resolution_width: 600, resolution_height: 800)

    TrafficSpy::Request.create(url: "http://www.mrs_client.com/contact", ip: "1", source_id: TrafficSpy::Source.find_by(identifier: "mrs_client").id, user_agent_id: user_agent.id, responded_in: 30, resolution_width: 600, resolution_height: 800)
  end


  def test_it_has_a_header_message
    create_requests

    visit '/sources/mrs_client/urls/blog'
    within('#header') do
      assert page.has_content?("Data Analysis for: http://www.mrs_client.com/blog")
    end
  end

  def test_it_shows_an_error_page_when_url_doesnt_exist
    create_requests

    visit '/sources/mrs_client/urls/no_exist_page'
    within("#error") do
      assert page.has_content?("This account is unregistered or the url doesn't exist")
    end
  end

  def test_it_shows_longest_response_time
    create_requests

    visit '/sources/mrs_client/urls/blog'
    within("#longest") do
      assert page.has_content?("Longest Response Time: 33")
    end
  end

  def test_it_shows_shortest_response_time
    create_requests

    visit '/sources/mrs_client/urls/blog'
    within("#shortest") do
      assert page.has_content?("Shortest Response Time: 31")
    end
  end

  def test_it_shows_average_response_time
    create_requests

    visit '/sources/mrs_client/urls/blog'
    within("#average") do
      assert page.has_content?("Average Response Time: 32")
    end
  end
end
