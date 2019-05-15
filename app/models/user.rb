require "./lib/recommendation.rb"

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :votes
  has_many :works, :through => :votes

  # include module recommendation
  include Recommendation
end
