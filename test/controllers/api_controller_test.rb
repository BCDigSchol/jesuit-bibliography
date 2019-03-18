require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get api_list_url
    assert_response :success
  end

end
