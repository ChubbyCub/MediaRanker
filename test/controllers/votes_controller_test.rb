require "test_helper"

describe VotesController do
  before do
    @work = works(:avenger)
    @user = perform_login
  end

  it "should allow upvote when the user is logged in and has never voted for the work before" do
    expect {
      post work_votes_path(@work.id)
    }.must_change "Vote.count", 1

    expect(flash[:success]).must_equal "Successfully upvoted!"
    expect(@work.vote_ids.last).must_equal Vote.last.id
    expect(@user.vote_ids.last).must_equal Vote.last.id
  end

  it "should not allow upvote when the user is logged in and has voted for the work before" do
    # upvote once
    post work_votes_path(@work.id)

    # upvote twice
    expect {
      post work_votes_path(@work.id)
    }.wont_change "Vote.count"

    expect(flash.now[:user]).must_equal "has already voted for this work"
  end

  it "should not allow up vote when the user is not logged in" do
    post logout_path

    post work_votes_path(@work.id)

    expect(flash[:error]).must_equal "You must log in to vote"
  end
end
