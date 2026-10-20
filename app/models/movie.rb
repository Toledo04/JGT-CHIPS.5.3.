class Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list, sort_by = nil)
    relation = ratings_list.nil? ? all : where(rating: ratings_list)
    
    if sort_by.present?
      relation.order(sort_by)
    else
      relation
    end
  end
end