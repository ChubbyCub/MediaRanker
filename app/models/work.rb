class Work < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :category, presence: true

  has_many :votes
  has_many :users, :through => :votes
end
