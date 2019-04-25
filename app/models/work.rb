class Work < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :category, presence: true

  has_many :votes
  has_many :users, :through => :votes

  def self.most_voted
    max_votes = 0
    result = nil
    Work.all.each do |work|
      num_votes = work.vote_ids.length
      if num_votes > max_votes
        max_votes = num_votes
        result = work
      end
    end
    return result
  end
end
