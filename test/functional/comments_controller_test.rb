require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def dummy_user
    user = User.new
    user.email = "foo@bar.com"
    user.name = "validname"
    user.password = "asdf1234"
    user.password_confirmation = "asdf1234"

    return user
  end

  def dummy_blogpost(user)
    blogpost = Blogpost.new
    blogpost.caption = "Try this test"
    blogpost.content = "Lorem Ipsum dolor sit amet"
    blogpost.user = user

    return blogpost
  end

  test "should create comment for an unregistered user" do
    # given
    user = dummy_user
    assert user.save, "Creating a test user failed"

    blogpost = dummy_blogpost(user)
    assert blogpost.save, "Creating a test blogpost failed"

    # when
    post(:create, blogpost_id: blogpost.id, name: "Smitty",  comment: {content: "This is a comment by an unregistered user."})

    #then
    assert_response(:found)
    comments = Comment.where(predecessor_id: blogpost.id, predecessor_type: "Blogpost")
    assert_equal 1, comments.length, "Expected exactly one comment"
    assert_equal "This is a comment by an unregistered user.", comments[0].content
  end

  test "should not create comment if precontent honeypot is filled" do
    # given
    user = dummy_user
    assert user.save, "Creating a test user failed"

    blogpost = dummy_blogpost(user)
    assert blogpost.save, "Creating a test blogpost failed"

    # when
    post(:create, blogpost_id: blogpost.id, precontent: "not empty", name: "Smitty",  comment: {content: "This is a comment by an unregistered user."})

    #then
    assert_response(:found)
    comments = Comment.where(predecessor_id: blogpost.id, predecessor_type: "Blogpost")
    assert comments.empty?
  end

  test "should not create comment if postcontent honeypot is filled" do
    # given
    user = dummy_user
    assert user.save, "Creating a test user failed"

    blogpost = dummy_blogpost(user)
    assert blogpost.save, "Creating a test blogpost failed"

    # when
    post(:create, blogpost_id: blogpost.id, postcontent: "not empty", name: "Smitty",  comment: {content: "This is a comment by an unregistered user."})

    #then
    assert_response(:found)
    comments = Comment.where(predecessor_id: blogpost.id, predecessor_type: "Blogpost")
    assert comments.empty?
  end
end
