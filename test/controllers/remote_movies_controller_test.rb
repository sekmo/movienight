require 'test_helper'

class RemoteMoviesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get remote_movies_index_url
    assert_response :success
  end

end
