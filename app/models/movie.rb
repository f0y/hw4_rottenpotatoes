class Movie < ActiveRecord::Base

  class Movie::InvalidKeyError < StandardError;
  end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def similar
    Movie.all :conditions => ["id != ? AND director = ?", self.id, self.director]
  end

end
