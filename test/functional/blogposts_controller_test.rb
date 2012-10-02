require 'test_helper'

class BlogpostsControllerTest < ActionController::TestCase
  test "should get confirm_destroy" do
    get :confirm_destroy
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
