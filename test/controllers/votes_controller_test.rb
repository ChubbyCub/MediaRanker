require "test_helper"

describe VotesController do
  it "should get new" do
    get votes_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get votes_create_url
    value(response).must_be :success?
  end

end
