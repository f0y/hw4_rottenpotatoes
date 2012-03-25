require 'spec_helper'

describe Movie do

  describe 'searching similar movies' do

    it 'should return similar movies' do
      movie_orig = Movie.create(:title => 'test_title', :director => 'test_director')
      movie_similar = Movie.create(:title => 'test_title_2', :director => 'test_director')
      Movie.create(:title => 'test_title_2', :director => 'test_director_1')
      movie_orig.similar.should == [movie_similar]
    end

  end


end