require "test_helper"

class SharedCodesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shared_codes_index_url
    assert_response :success
  end
end
