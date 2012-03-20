# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movie_count = 0
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.

    Movie.create!(movie) unless Movie.find_by_title(movie[:title])
    movie_count = movie_count + 1
  end
  Movie.all.length.should >= movie_count
#  assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|  
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  
  rating_list.split(', ').each do |rating|
    if uncheck 
      uncheck('ratings_'+rating)
    else
      check('ratings_'+rating)
    end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

When /I press the '(.*)' button/ do |button|
  click_button(button)
end

Then /I should see (only)? movies with following ratings: (.*)/ do |only, rating_list|
  movies = Movie.all
  movies.each do |movie|
    if rating_list.split(", ").include?(movie[:rating])
      page.body.match("<td(.*)>"+movie[:title]+"</td>").should_not == nil
    elsif only
      page.body.match("<td(.*)>"+movie[:title]+"</td>").should == nil
    end
  end  
end

When /I check (all|no) ratings/ do |how_many|
  Movie.all_ratings.each do |rating|
    if how_many == "all"
      check('ratings_'+rating)
    else
      uncheck('ratings_'+rating)
    end
  end
end

Then /I should see (all|no) movies/ do |how_many|
  
  #page.body.match("<table(.|\\n)*id=\"movies\">(.|\\n)*</table>").to_s.match("<tbody>(.|\\n)*</tbody>").should == nil
  
  scan_result = page.body.match("<table(.|\\n)*id=\"movies\">(.|\\n)*</table>").to_s.match("<tbody>(.|\\n)*</tbody>").to_s.scan(/<tr>(.|\\n)*/)
  
    if how_many == "no"
      scan_result.length.should == 0
    else
      scan_result.length.should == Movie.all.length  
    end  
    
end  


Then /I should see the movies sorted (alphabetically|in increasing order of release date)/ do |sort_type|
  scan_result = page.body.match("<table(.|\\n)*id=\"movies\">(.|\\n)*</table>").to_s.match("<tbody>(.|\\n)*</tbody>").to_s.scan(/<tr>(.*?)<\/tr>/m) 
  movies = ""
  
  if sort_type == "alphabetically"
    movies = Movie.order("title")
  else
    movies = Movie.order("release_date asc")
  end
  
  index = 0
  
  movies.each do |movie|
    scan_result[index].to_s.match(movie[:title]).should_not == nil
    index = index + 1
  end
    
end

Then /the director of "(.*)" should be "(.*)"/ do |movie_title, director| 

  page.body.match("Details about.*"+movie_title).should_not == nil
  page.body.match("Director(.|\\n)*"+director).should_not == nil
end