require './test/test_helper'

class DashboardPageTest < MiniTest::Test
  def test_the_user_sees_an_error_message_when_there_is_no_identifier
    visit '/sources/non_registered_account'
    within('#error') do
      assert page.has_content?("This account is unregistered")
    end
  end
end
