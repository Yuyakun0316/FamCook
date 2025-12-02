require "test_helper"

class FamilyMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get family_members_index_url
    assert_response :success
  end
end
