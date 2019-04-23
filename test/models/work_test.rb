require "test_helper"

describe Work do
  let(:work) { works(:avenger) }

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
end
