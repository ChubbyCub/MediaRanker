require "test_helper"

describe Work do
  let(:work) { works(:avenger) }
  let(:user) { users(:one) }

  it "must be valid" do
    valid = work.valid?
    expect(valid).must_equal true
  end

  describe "validations" do
    it "requires a title" do
      work.title = nil

      valid_work = work.valid?

      expect(valid_work).must_equal false
      expect(work.errors.messages).must_include :title
      expect(work.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "requires a unique title" do
      duplicate_work = Work.new(title: work.title)

      expect(duplicate_work.save).must_equal false
      expect(duplicate_work.errors.messages).must_include :title
      expect(duplicate_work.errors.messages[:title]).must_equal ["has already been taken"]
    end
  end

  describe "most voted" do
    it "should return a work that was voted most" do
      vote = Vote.new(work_id: work.id, user_id: user.id)
      vote.save
      expect(Work.most_voted).must_be_instance_of Work
      expect(Work.most_voted.id).must_equal work.id
    end
  end

  describe "top ten" do
    let(:books) { Work.where(category: "book") }
    let(:albums) { Work.where(category: "album") }
    let(:movies) { Work.where(category: "movie") }

    it "should return a list of works that belong to book category" do
      expect(Work.top_ten("book").length).must_equal books.length

      works(:statistics).destroy
      works(:thinking).destroy

      expect(Work.top_ten("book").length).must_equal books.length - 2
    end

    it "should return a list of works that belong to album category" do
      expect(Work.top_ten("album").length).must_equal albums.length

      works(:home).destroy

      expect(Work.top_ten("album").length).must_equal albums.length - 1
    end

    it "should return a list of works that belong to movie category" do
      expect(Work.top_ten("movie").length).must_equal movies.length

      works(:dragon).destroy

      expect(Work.top_ten("movie").length).must_equal movies.length - 1
    end
  end
end
