require "test_helper"

describe WorksController do
  let(:work) { works(:thinking) }

  it "should get index" do
    get works_path
    must_respond_with :success
  end

  describe "show" do
    it "should get show given a valid media id" do
      get work_path(work.id)
      must_respond_with :success
    end

    it "should respond with 404 given an invalid media id" do
      work_id = work.id
      work.destroy
      get work_path(work_id)
      must_respond_with :not_found
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

      new_work = Work.find_by(title: input_title)
      expect(new_work).wont_be_nil
      expect(new_work.category).must_equal input_category
      expect(new_work.title).must_equal input_title
      expect(new_work.publication_year).must_equal input_publication_year
      expect(new_work.creator).must_equal input_creator
      expect(new_work.description).must_equal input_description

      must_respond_with :redirect
    end

    it "will return a 400 with an invalid media" do
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

      must_respond_with :bad_request
    end
  end

  it "should get edit" do
    get edit_work_path(works(:avenger))
    must_respond_with :success
  end

  describe "update" do
    it "will update an existing media" do
      work_to_update = works(:avenger)

      input_title = "Avengers: End Game"

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
      expect(work_to_update.title).must_equal test_input[:work][:title]
    end

    it "will return a bad_request (400) when asked to update with invalid data" do
      work_to_update = works(:hello)

      input_title = ""
      test_input = {
        "work": {
          title: input_title,
        },
      }

      expect {
        patch work_path(work_to_update.id), params: test_input
      }.wont_change "Work.count"

      must_respond_with :bad_request
      work_to_update.reload
      expect(work_to_update.title).must_equal work_to_update.title
    end
  end

  describe "destroy" do
    it "returns a 404 if the book is not found" do
      delete work_path("INVALID ID")
      must_respond_with :not_found
    end

    it "can delete a book" do
      expect {
        delete work_path(works(:thinking).id)
      }.must_change "Work.count", -1

      must_respond_with :redirect
      must_redirect_to works_path
    end
  end
end
