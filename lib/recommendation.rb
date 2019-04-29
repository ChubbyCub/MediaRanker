require "pry"

module Recommendation
  def recommend_works
    other_users = self.class.all.where.not(id: self.id)
    recommended = Hash.new(0)
    other_users.each do |user|
      common_works = user.works & self.works
      weight = common_works.size.to_f / user.works.size
      (user.works - common_works).each do |work|
        recommended[work] += weight
      end
    end

    return recommended.sort_by { |key, value| value }.reverse
  end
end
