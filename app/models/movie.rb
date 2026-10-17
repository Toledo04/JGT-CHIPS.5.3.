class Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list)
    return all if ratings_list.blank?
    
    ratings = if ratings_list.is_a?(Hash) || ratings_list.respond_to?(:keys)
                ratings_list.keys
              elsif ratings_list.is_a?(Array)
                ratings_list
              else
                Array(ratings_list)
              end
              
    return all if ratings.blank?
    
    upper_ratings = ratings.map(&:to_s).map(&:upcase)
    where('UPPER(rating) IN (?)', upper_ratings)
  end
endclass Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list)
    return all if ratings_list.blank?
    
    ratings = if ratings_list.is_a?(Hash) || ratings_list.respond_to?(:keys)
                ratings_list.keys
              elsif ratings_list.is_a?(Array)
                ratings_list
              else
                Array(ratings_list)
              end
              
    return all if ratings.blank?
    
    upper_ratings = ratings.map(&:to_s).map(&:upcase)
    where('UPPER(rating) IN (?)', upper_ratings)
  end
end