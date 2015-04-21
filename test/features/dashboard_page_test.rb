require './test/test_helper'

class DashboardPageTest < MiniTest::Test
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
end
