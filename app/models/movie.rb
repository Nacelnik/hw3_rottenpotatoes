class Movie < ActiveRecord::Base
  
  def possible_ratings 
    return ['G','PG','PG-13','R','NC-17']
  end

end
