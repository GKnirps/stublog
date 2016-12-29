require 'test_helper'

def dummy_user
    user = User.new
    user.email = "foo@bar.com"
    user.name = "validname"
    user.password = "asdf1234"
    user.password_confirmation = "asdf1234"

    return user
end

class UserTest < ActiveSupport::TestCase
  test "should validate username presence" do
    # given
    user = dummy_user
    user.name = nil

    # when
    user.valid?

    # then
    assert user.errors[:name].any?, "Expected absent username to be an error."
  end

  test "should validate username not to be empty" do
    # given
    user = dummy_user
    user.name = ""

    # when
    user.valid?

    # then
    assert user.errors[:name].any?, "Expected empty username to be an error."
  end

  test "should validate username max length" do
    # given
    user = dummy_user
    user.name = "x" * 43

    # when
    user.valid?

    # then
    assert user.errors[:name].any?, "Expected overly long username to be an error."
  end

  test "should validate username uniqueness" do
    # given
    user1 = dummy_user
    user1.email = "foo1@bar.com"
    user1.name = "valid_dummy_user"

    userdup = dummy_user
    userdup.email = "foo2@bar.com"
    userdup.name = "valid_dummy_user"

    # when
    assert user1.save, "Creating an existing user for duplication test failed"
    userdup.valid?

    # then
    assert userdup.errors[:name].any?, "Expected duplicate user to raise an error"

  end

  test "should validate email presence" do
    # given
    user = dummy_user
    user.email = nil

    # when
    user.valid?

    # then
    assert user.errors[:email].any?, "Expected absent email to be an error."
  end

  test "should validate email not to be empty" do
    # given
    user = dummy_user
    user.email = ''

    # when
    user.valid?

    # then
    assert user.errors[:email].any?, "Expected empty email to be an error."
  end

  ["foobar.com", "@foobar.com", "foobar@", "foo@bar", "foo@.com"].each do |email|
    test "should filter out invalid email: %s" % email do
      # given
      user = dummy_user
      user.email = email

      # when
      user.invalid?

      assert user.errors[:email].any?, "Expected email %s to be invalid" % email
    end
  end

  ["foo@foobar.com", "foo@foobar.berlin", "foobar@bar.de"].each do |email|
    test "should not filter out valid email: %s" % email do
      # given
      user = dummy_user
      user.email = email

      # when/then
      assert user.valid?, "Expected no email address %s to be valid" % email
    end
  end

  test "should validate email uniqueness" do
    # given
    user1 = dummy_user
    user1.email = "foo1@bar.com"
    user1.name = "valid_dummy_user"

    userdup = dummy_user
    userdup.email = "foo1@bar.com"
    userdup.name = "different_dummy_user"

    # when
    assert user1.save, "Creating an existing user for duplication test failed"
    userdup.valid?

    # then
    assert userdup.errors[:email].any?, "Expected duplicate email to raise an error"
  end

  test "should make email lowercase before saving" do
    # given
    user = dummy_user
    user.email = "MixEdcASe@foobar.coM"

    # when
    user.save!

    # then
    assert_equal "mixedcase@foobar.com", user.email, "Expected email to be lowercased."
  end

  test "should create session token before saving" do
    # given
    user = dummy_user

    # when
    user.save!

    # then
    assert user.remember_token, "Expected remember:token to exist."
  end

  test "should validate password length" do
    # given
    user = dummy_user
    user.password = "fooba"
    user.password_confirmation = "fooba"

    # when
    user.valid?

    # then
    assert user.errors[:password].any?, "Expected short password to be an error."
  end

  test "should validate password confirmation" do
    # given
    user = dummy_user
    user.password = "foobar1"
    user.password_confirmation = "foobar2"

    # when
    user.valid?

    # then
    assert user.errors[:password].any?, "Expected wrong password confirmation to be an error."
  end

  test "should salt password hashes" do
    # given
    user1 = dummy_user
    user1.email = "foo1@bar.com"
    user1.name = "valid_dummy_user"

    user2 = dummy_user
    user2.email = "foo2@bar.com"
    user2.name = "different_dummy_user"

    # when
    assert user1.save, "Creating user1 for password salt test failed"
    assert user2.save, "Creating user1 for password salt test failed"

    # then
    assert user1.password_digest, "Expected a password digest for user 1"
    assert user2.password_digest, "Expected a password digest for user 2"

    assert_not_equal user1.password_digest, user2.password_digest, "Expected password digests for user 1 and 2 to be different (=> they are unsalted)"
  end
end
