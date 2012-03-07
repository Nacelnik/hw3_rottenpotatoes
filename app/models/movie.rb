class Movie < ActiveRecord::Base
  @@possible_ratings = ['G','PG','PG-13','R','NC-17']

  def getPossibleRatings()
    @@possible_ratings
  end

end
