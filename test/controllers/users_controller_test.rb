require "test_helper"

describe UsersController do
  let(:sample_user) { users(:one) }

  it "should get login_form" do
    get login_path
    must_respond_with :success
  end

  describe "log in action" do
    it "should display flash success for existing users" do
      test_input = {
        "user": {
          username: sample_user.username,
        },
      }

      expect {
        post login_path, params: test_input
      }.wont_change "User.count"

      expect(flash[:success]).must_equal "Successfully logged in as an existing user #{sample_user.username}"
    end

    it "should display flash success for new user" do
      test_input = {
        "user": {
          username: "abc",
        },
      }
      expect {
        post login_path, params: test_input
      }.must_change "User.count", 1

      expect(flash[:success]).must_equal "Successfully logged in as a new user #{test_input[:user][:username]}"
    end
  end

  describe "current action" do
    it "should get current user page" do
      test_input = {
        "user": {
          username: sample_user.username,
        },
      }
      post login_path, params: test_input
      expect(session[:user_id]).must_equal sample_user.id

      get current_user_path
      must_respond_with :success
    end
  end

  describe "logout" do
    it "should log a user out" do
      test_input = {
        "user": {
          username: sample_user.username,
        },
      }
      post login_path, params: test_input
      expect(session[:user_id]).must_equal sample_user.id

      post logout_path
      expect(session[:user_id]).must_be_nil
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end