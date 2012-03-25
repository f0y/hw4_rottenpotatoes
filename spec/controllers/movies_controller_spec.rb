require 'spec_helper'

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [mock('Movie'), mock('Movie')]
    end
    it 'should call the model method that performs TMDb search' do
      Movie.should_receive(:find_in_tmdb).with('hardware').
          and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
    end
    describe 'after valid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movies).should == @fake_results
      end
    end
  end

  describe 'searching for similar movies' do

    before :each do
      @movie = mock('Movie')
      @movies = [mock('Movie1'), mock('Movie2')]
      Movie.stub(:find).and_return(@movie)
      @movie.stub(:similar).and_return(@movies)
    end

    it 'should find the movie with given id' do
      Movie.should_receive(:find).with('1')
      get :similar, {:id => '1'}
    end

    it 'should call the model method that searches for similar movies' do
      @movie.should_receive(:similar)
      get :similar, {:id => '1'}
    end

    it 'should pass similar movies to the view' do
      get :similar, {:id => '1'}
      assigns(:movies).should == @movies
    end

  end
end