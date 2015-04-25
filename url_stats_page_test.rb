require './test/test_helper'

class UrlStatPageTest < MiniTest::Test
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_it_has_a_header_message
    within('#header') do
      assert page.has_content?("Data Analysis for:")
    end
  end

end
