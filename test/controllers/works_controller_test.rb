require "test_helper"

describe WorksController do
  let(:work) { works(:book_1) }

  it "should get index" do
    get works_path
    must_respond_with :success
  end

  describe "show" do
    it "should get show given a valid media id" do
      get work_path(work.id)
      must_respond_with :success
    end

    it "should respond with flash message (invalid work) given an invalid media id" do
      work_id = work.id
      work.destroy
      get work_path(work_id)
      expect(flash[:error]).must_equal "Invalid work"
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  it "should get new" do
    get new_work_path
    must_respond_with :success
  end

  describe "create" do
    it "will save a new media and redirect if given valid inputs" do
      input_category = "book"
      input_title = "Practical Object Oriented Programming in Ruby"
      input_publication_year = 1990
      input_creator = "Sandi Metz"
      input_description = "A look at how to design object-oriented systems"
      test_input = {
        "work": {
          category: input_category,
          title: input_title,
          publication_year: input_publication_year,
          creator: input_creator,
          description: input_description,
        },
      }

      expect {
        post works_path, params: test_input
      }.must_change "Work.count", 1

      expect(flash[:success]).must_equal "Successfully created new work!"

      new_work = Work.find_by(title: input_title)
      expect(new_work).wont_be_nil
      expect(new_work.category).must_equal input_category
      expect(new_work.title).must_equal input_title
      expect(new_work.publication_year).must_equal input_publication_year
      expect(new_work.creator).must_equal input_creator
      expect(new_work.description).must_equal input_description

      must_respond_with :redirect
    end

    it "will display flash messages with an invalid work" do
      input_category = "book"
      input_title = ""
      input_publication_year = 1990
      input_creator = ""
      input_description = "A look at how to design object-oriented systems"
      test_input = {
        "work": {
          category: input_category,
          title: input_title,
          publication_year: input_publication_year,
          creator: input_creator,
          description: input_description,
        },
      }

      expect {
        post works_path, params: test_input
      }.wont_change "Work.count"

      expect(flash[:title]).must_equal ["can't be blank"]
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "should get edit" do
      get edit_work_path(works(:album_1))
      must_respond_with :success
    end

    it "should bring up flash error message when given invalid id" do
      work_id = work.id
      work.destroy
      get edit_work_path(work_id)
      expect(flash[:error]).must_equal "Invalid work"
      must_respond_with :redirect
      must_redirect_to works_path
    end
  end

  describe "update" do
    it "will update an existing media" do
      work_to_update = works(:movie_2)

      input_title = "Meow"

      test_input = {
        "work": {
          title: input_title,
        },
      }

      expect {
        patch work_path(work_to_update.id), params: test_input
      }.wont_change "Work.count"

      must_respond_with :redirect
      work_to_update.reload
      expect(flash[:success]).must_equal "Successfully updated #{work_to_update.title}"
      expect(work_to_update.title).must_equal test_input[:work][:title]
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      work_to_update = works(:album_5)

      input_title = ""
      test_input = {
        "work": {
          title: input_title,
        },
      }

      expect {
        patch work_path(work_to_update.id), params: test_input
      }.wont_change "Work.count"

      expect(flash[:title]).must_equal ["can't be blank"]

      must_respond_with :bad_request
      work_to_update.reload
      expect(work_to_update.title).must_equal work_to_update.title
    end
  end

  describe "destroy" do
    it "returns a flash error message if the work is not found" do
      delete work_path("INVALID ID")
      expect(flash[:error]).must_equal "Invalid work"
      must_respond_with :redirect
      must_redirect_to works_path
    end

    it "can delete a book" do
      expect {
        delete work_path(work.id)
      }.must_change "Work.count", -1

      expect(flash[:success]).must_equal "Successfully deleted #{work.title}"
      must_respond_with :redirect
      must_redirect_to works_path
    end
  end
end
