require 'test_helper'

def dummy_user
    user = User.new
    user.email = "foo@bar.com"
    user.name = "validname"
    user.password = "asdf1234"
    user.password_confirmation = "asdf1234"

    return user
end

class SessionsHelperTest < ActionView::TestCase
  test "should create a token and set it as cookie on sign in" do
    # given
    user = dummy_user
    user.save

    assert_nil cookies[:remember_token], "Found remember token cookie before testing token creation."
    assert_nil current_user, "Expected no current user before login."

    # when
    sign_in user, false

    # then
    assert_same user, current_user, "Expected user to be current user on login."
    assert_not_nil cookies[:remember_token], "Expected a token cookie"
  end

  test "should delete the session cookie and set the current user to nil on sign out" do
    # given
    user = dummy_user
    user.save
    # user was signed in before
    sign_in user, false

    current_token = current_user.remember_token
    assert_not_nil current_token, "Expected token to exist for logged in user."
    assert_equal current_token, cookies[:remember_token]

    # when
    sign_out

    # then
    assert_nil current_user, "Expected no user after login"
    assert_not_equal current_token, user.remember_token, "Expected no current token."
    assert_nil cookies[:remember_token], "Expected cookies to be deleted."
  end

end
