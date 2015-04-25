require './test/test_helper'

class DashboardPageTest < MiniTest::Test
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
    create_requests

    assert_equal 1, TrafficSpy::Source.where(identifier: "mrs_client").count
    assert_equal 1, TrafficSpy::Source.all.count
    assert_equal 4, TrafficSpy::Request.all.count

    visit '/sources/mrs_client'
    within('#urls') do
      assert page.has_content?("Top requested URL's:")
      assert page.has_content?("1:  http://www.mrs_client.com/blog
                               2: http://www.mrs_client.com/contact")
    end
  end

  def test_the_user_sees_browser_breakdown_for_all_requests
    create_requests

    visit '/sources/mrs_client'
    within('#browsers') do
      assert page.has_content?("Browsers Used:")
      assert page.has_content?("chrome")
    end
  end

  def test_the_user_sees_screen_resolution_breakdown_for_all_requests
    create_requests

    visit '/sources/mrs_client'
    within('#screen_resolutions') do
      assert page.has_content?("Screen Resolutions Used")
      assert page.has_content?("Width: 600, Height: 800")
    end
  end

  def test_the_user_sees_average_response_times_breakdown_for_all_requests
    create_requests

    visit '/sources/mrs_client'
    within('#avg_response_times') do
      assert page.has_content?("Average Response Time for each URL:")
      assert page.has_content?("http://www.mrs_client.com/blog, 32")
      assert page.has_content?("http://www.mrs_client.com/contact, 30")
    end
  end

  def test_the_user_sees_link_to_url_specific_data
    create_requests

    visit '/sources/mrs_client'
    within('#links') do
      assert page.has_content?("http://www.mrs_client.com/blog")
      assert page.has_content?("http://www.mrs_client.com/contact")
    end

    click_link_or_button("http://www.mrs_client.com/blog")
    assert_equal '/sources/mrs_client/urls/blog', current_path
  end
end
