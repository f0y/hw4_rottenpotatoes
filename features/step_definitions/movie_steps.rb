# Add a declarative step here for populating the DB with movies.

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

When /^I (?:am on|go to) the (.*) page for "(.*)"/ do |action, movie_title|
  movie = Movie.find_by_title(movie_title)
  visit "/movies/#{movie.id}/#{action}"
end

Given /^PENDING:/ do
  pending
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie_title, director|
  movie = Movie.find_by_title(movie_title)
  visit "/movies/#{movie.id}"
  step "I should see \"#{director}\""
end