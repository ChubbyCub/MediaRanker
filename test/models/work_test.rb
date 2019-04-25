require "test_helper"

describe Work do
  let(:work) { works(:movie_10) }
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

  describe "relationship" do
    it "can have no vote" do
      expect(work.votes.length).must_equal 0
    end

    it "can have one or more votes" do
      new_vote = Vote.new(user_id: users(:two).id, work_id: work.id)
      new_vote.save

      another_vote = Vote.new(user_id: user.id, work_id: work.id)
      another_vote.save

      expect(work.votes.length).must_equal 2
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

  describe "top ten books" do
    let(:books) { Work.where(category: "book") }

    it "should return a list of works that belong to book category" do
      expect(Work.top_ten("book")).must_be_kind_of Array
    end

    it "should return a list of 10 books" do
      expect(Work.top_ten("book").length).must_equal 10
    end

    it "should return a truncated list of books after some being deleted" do
      num_books = books.length

      works(:book_5).destroy
      works(:book_6).destroy

      expect(Work.top_ten("book").length).must_equal num_books - 2
    end

    it "should return an empty list if no books exist" do
      books.each do |book|
        book.destroy
      end
      expect(Work.top_ten("book")).must_be_empty
    end
  end

  describe "top ten movies" do
    let(:movies) { Work.where(category: "movie") }

    it "should return a list of works that belong to movie category" do
      expect(Work.top_ten("movie")).must_be_kind_of Array
    end

    it "should return a list of 10 movies" do
      expect(Work.top_ten("movie").length).must_equal 10
    end

    it "should return a truncated list of movies after some being deleted" do
      num_movies = movies.length

      works(:movie_5).destroy
      works(:movie_6).destroy

      expect(Work.top_ten("movie").length).must_equal num_movies - 2
    end

    it "should return an empty list if no movies exist" do
      movies.each do |movie|
        movie.destroy
      end
      expect(Work.top_ten("movie")).must_be_empty
    end
  end

  describe "top ten albums" do
    let(:albums) { Work.where(category: "album") }

    it "should return a list of works that belong to album category" do
      expect(Work.top_ten("album")).must_be_kind_of Array
    end

    it "should return a list of 10 movies" do
      expect(Work.top_ten("album").length).must_equal 10
    end

    it "should return a truncated list of books after some being deleted" do
      num_albums = albums.length

      works(:album_5).destroy
      works(:album_6).destroy

      expect(Work.top_ten("album").length).must_equal num_albums - 2
    end

    it "should return an empty list if no books exist" do
      albums.each do |album|
        album.destroy
      end
      expect(Work.top_ten("album")).must_be_empty
    end
  end

  describe "top ten" do
    it "should return a list in a different order when number of votes change" do
      # book 5 was ranked first
      perform_vote(work_id: works(:book_5).id, user_id: users(:one).id)
      expect(Work.top_ten("book").first.id).must_equal works(:book_5).id

      # book 6 is now ranked first
      perform_vote(work_id: works(:book_6).id, user_id: users(:one).id)
      perform_vote(work_id: works(:book_6).id, user_id: users(:two).id)

      expect(Work.top_ten("book").first.id).must_equal works(:book_6).id
    end
  end
end
