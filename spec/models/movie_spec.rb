require 'spec_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    it 'should call Tmdb with title keywords given valid API key' do
      TmdbMovie.should_receive(:find).
          with(hash_including :title => 'Inception')
      Movie.find_in_tmdb('Inception')
    end
    it 'should raise an InvalidKeyError with no API key' do
      TmdbMovie.stub(:find).
          and_raise(ArgumentError.new('No key provided'))
      lambda { Movie.find_in_tmdb('Inception') }.
          should raise_error(Movie::InvalidKeyError)
    end
    it 'should raise an InvalidKeyError with invalid API key' do
      TmdbMovie.stub(:find).
          and_raise(RuntimeError.new('API returned code 404'))
      Movie.stub(:api_key).and_return('INVALID')
      lambda { Movie.find_in_tmdb('Inception') }.
          should raise_error(Movie::InvalidKeyError)
    end
  end

  describe 'searching similar movies' do

    before :each do
      @movie_orig = Movie.create(:title => 'test_title', :director => 'test_director')
      @movie_similar = Movie.create(:title => 'test_title_2', :director => 'test_director')
      @movie_not_similar = Movie.create(:title => 'test_title_2', :director => 'test_director_1')
    end

    it 'should return similar movies' do
      @movie_orig.similar.should == [@movie_similar]
    end

  end


end