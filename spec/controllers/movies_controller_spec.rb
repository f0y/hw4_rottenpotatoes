require 'spec_helper'

describe MoviesController do

  describe 'searching for similar movies' do

    before :each do
      @movie = mock('Movie')
      @movies = [mock('Movie1'), mock('Movie2')]
      Movie.stub(:find).and_return(@movie)
      @movie.stub(:similar).and_return(@movies)
      @movie.stub(:director).and_return("test_director")
      @movie.stub(:title).and_return("test_title")
    end

    it 'should find the movie with given id' do
      Movie.should_receive(:find).with('1')
      get :similar, {:id => '1'}
    end

    it 'should call the model method that searches for similar movies' do
      @movie.should_receive(:similar)
      get :similar, {:id => '1'}
    end

    context 'if movie has a director info' do

      before :each do
        get :similar, {:id => '1'}
      end

      it 'should pass similar movies to the view' do
        assigns(:movies).should == @movies
      end

      it 'should render the similar movies page' do
        response.should render_template('similar')
      end

    end

    context 'if no director info exist' do
      before :each do
        @movie.stub(:director).and_return(nil)
        get :similar, {:id => '1'}
      end

      it 'should redirect to home page' do
        response.code.should == "302"
        response.should redirect_to movies_path
      end

      it 'should pass redirect to home page and pass the notice message if no director info present' do
        flash[:notice].should == "'test_title' has no director info"
      end

    end

  end

  describe 'deleting a movie' do
    it 'should destroy movie' do
      movie = mock(:id => '1', :title => 'test_title')
      Movie.stub(:find).and_return(movie)
      movie.should_receive(:destroy)
      Movie.should_receive(:find)
      post :destroy, {:id => '1'}
    end
  end

  describe 'creating a movie' do
    it 'should create a movie' do
      movie = mock(:id => '1', :title => 'test_title')
      Movie.should_receive(:create!).and_return movie

      post :create
    end
  end

  describe 'showing a movie' do
    it 'should show a movie' do
      Fixnum.send(:include, MoviesHelper)
      5.oddness(5)
      get :index, {:sort => 'title'}
    end
    it 'should show a movie 2' do
      get :index, {:sort => 'release_date'}
    end

    it 'should show a movie 3' do
      get :index, {:sort => 'release_date', :ratings => ['PG']}
    end

    it 'should show a movie 4' do
      Movie.should_receive(:find)
      get :show, {:id => '1'}
    end

    it 'should show a movie 5' do
      get :index, {:sort => 'release_date', :ratings => 'PG'}, {:sort => 'release_date', :ratings => 'G'}
    end


    it 'should show a movie 6' do
      get :index, {:sort => 'release_date', :ratings => {'PG' => 't'}}, {:sort => 'release_date', :ratings => {'PG' => 't'}}
    end

    it 'update' do
      m = mock()
      Movie.should_receive(:find).and_return(m)
      m.should_receive(:update_attributes!)
      m.should_receive(:title)
      post :update, {:id => '1', :movie => 't'}
    end

  end

end