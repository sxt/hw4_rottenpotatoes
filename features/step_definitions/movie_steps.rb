# Add a declarative step here for populating the DB with movies.

movies_table_hashes = [
                       {:title => 'Star Wars', :rating => 'PG', :director => 'George Lucas', :release_date => '1977-05-25' },
                       {:title => 'Blade Runner', :rating => 'PG', :director => 'Ridley Scott', :release_date => '1982-06-25' },
                       {:title => 'Alien', :rating => 'R', :director => '', :release_date => '1979-05-25' },
                       {:title => 'THX-1138', :rating => 'R', :director => 'George Lucas', :release_date => '1971-03-11' }
                      ]
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |movie_name, director|
  movie = Movie.find_by_title(movie_name)
  movie.director.should eq(director)
end

When /^(?:|I )visit the edit page for "(.+)"$/ do |movie_name|
  #puts "## arg: " + movie_name.to_s
  movie = Movie.find_by_title(movie_name)
  #puts "## Movie id: " + movie.id.to_s
  visit path_to(movie.id.to_s+"/edit")
end

When /^I delete "([^"]*)"$/ do |arg1|
  movie = Movie.find_by_title(movie_name)

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end
Given /^I check: (.+)$/ do       |fields|
  all_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
  if fields == 'all'
    checked_ratings = all_ratings
  elsif fields == 'none'
    checked_ratings = []
  else
    checked_ratings = fields.split(", ")
  end
  checked_ratings.each do |field|
    puts "Checking " + "ratings_" + field
    check("ratings_"+field)
  end
  all_ratings.each do |ar|
    if checked_ratings.index(ar).nil?
      puts "UnChecking " + "ratings_" + ar
      uncheck("ratings_" + ar)
    end
  end
end

When /^I refresh$?/ do
  ########puts 'REFRESHING'
  page.find('#ratings_submit').click
end

Then /^I should see all of the movies$/ do
  trs = page.all('table#movies tbody tr')
  puts "Looking for ALL movies"
  trs.each do |tr|
    puts "** " + page.find(:xpath, tr.path+"/td[1]").text
  end
  puts ""
  all_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
  all_ratings.each do |rating|
    puts "*** " + rating + " checked? " + has_checked_field?("ratings_"+rating).to_s
  end
  rows = page.all('table#movies tbody tr').length.to_s
  page.all('table#movies tbody tr').length.to_s.should == '10'
  #page.all('table#movies tbody tr').length.to_s.should == rows
end

Then /^I should see (\d+) movies with ratings (.*)$/ do |count, ratings_str|

  ratings = ratings_str.split(", ")
  ratings.each do |rating|
    puts "-- should show rating " + rating
  end

  trs = page.all('table#movies tbody tr')
  puts "Looking for " + count.to_s + " movies"
  trs.each do |tr|
    puts "** " + page.find(:xpath, tr.path+"/td[1]").text
  end
  #puts "*** " + page.find("#ratings_G").checked?
  puts ""
  all_ratings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
  all_ratings.each do |rating|
    puts "*** " + rating + " checked? " + has_checked_field?("ratings_"+rating).to_s
  end
  page.all('table#movies tbody tr').length.to_s.should == count.to_s

  ratings.each do |rating|
    box = page.find("#ratings_"+rating);
    puts "-- Verifying checkbox " + "#ratings_"+rating
    box.should be_checked
  end
end

Then /^I should see (.*) before (.*)$/ do |before, after|

  tds = page.all('table#movies tbody tr td')
  trs = page.all('table#movies tbody tr')
  #puts "ZZ Row 1 path: " + trs[0].path
  #puts "ZZ Row 1 text " + page.find(:xpath, trs[0].path+"/td[1]").text

  #puts "YY td 1 path: " + tds[0].path
  #puts "YY td 1 text " + page.find(:xpath, tds[0].path).text

  titles = []
  trs.each do |tr|
    #puts "** " + page.find(:xpath, tr.path+"/td[1]").text
    titles << page.find(:xpath, tr.path+"/td[1]").text
  end

#  puts titles

  i_before = titles.index(before)
  i_after = titles.index(after)

#  puts "INX: " + i_before.to_s
#  puts "INX: " + i_after.to_s
  i_before.nil?.should eq (false)
  i_after.nil?.should eq (false)

  (i_before < i_after).should eq(true)

end
