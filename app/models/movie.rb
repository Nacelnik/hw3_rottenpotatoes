class Movie < ActiveRecord::Base

  def @@getPossibleRatings()
    ['G','PG','PG-13','R','NC-17']
  end

end
