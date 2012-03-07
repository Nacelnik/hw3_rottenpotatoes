class Movie < ActiveRecord::Base
  attr_reader @@possible_ratings = ['G','PG','PG-13','R','NC-17']
end
