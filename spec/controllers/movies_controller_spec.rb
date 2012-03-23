require 'spec_helper'

describe MoviesController do
  
  describe 'get list of all movies' do
    
    it 'should display the homepage' do
      get :index
      response.should render_template('index')
    end
    
    it 'should try to find all movies' do
      #Movie.should_receive(:find)
      Movie.should_receive(:find_all_by_rating)
      get :index
      #m=mock('Movie')
      #m.stub(:find_all_by_rating)
      
    end
    
    it 'should make the list of movies available to the view' do
      get :index
      Movie.stub(:find_all_by_rating)
      assigns[:@movies]
    end
    
    
    
    
  end
  
  describe 'get sorted list of all movies by title' do
    before(:each) do
      get :index, :sort=>'title'
    end
    
    it 'should redirect to the homepage ' do
       response.should redirect_to(movies_path(:sort=>'title', :ratings=>{}))
    end
   
    it 'should assign the session-sort variable' do
      assigns(:session)  
    end
  end
  
  describe 'get sorted list of all movies by release date' do
    before(:each) do
      get :index, :sort=>'release_date'
    end
    
    it 'should redirect to the homepage ' do
       response.should redirect_to(movies_path(:sort=>'release_date', :ratings=>{}))
    end
   
    it 'should assign the session-sort variable' do
      assigns(:session)  
    end
  end
  
  describe 'try to create a movie' do
    it 'should post the parameters and create something' do
      post 'create',:movie=>{:title=>'ABCD',:director=>'EDFJ'}
      assigns[:@movie]#.should be_new_record
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end
  end
  
  describe 'try to delete a movie' do
    it 'should delete the movie' do
      Movie.create!(:id=>1, :title=>'Test movie', :director=>'director')
      get :destroy, {:id=>1}
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end
  end
  
   
  
  
  
  describe 'adding director to an existing movie' do
    before(:each) do
      Movie.create!(:id=>1, :title=>'Test movie')  
    end
    
    it 'should find the movie' do
      Movie.should_receive(:find).with("1")
      get :edit, :id => 1
      
    end
    
    it 'should display the edit page for the movie' do
      get :edit, :id => 1
      response.should render_template('edit')
    end
    
    
    it 'should call the movie model method that updates the record with new director value' do
      m = mock('Movie')
      m.stub!(:update_attributes!)#.stub!(:update_attributes)
      m.stub!(:title).and_return('TEST')
      Movie.stub!(:find).and_return(m)
      
     
      m.should_receive(:update_attributes!)#.with(hash_including :director => 'director')
      
      put :update, :id => 1, :director=>'director'
      
      
           
    end
    
    it 'should render the details template for the movie' do
      put :update, :id => 1, :director=>'director'
      response.should redirect_to('/movies/1')
    end
   
    end
    
    describe 'get list of movies with a defined director' do
      before(:each) do
        Movie.create!(:id=>1, :title=>'Test movie', :director=>'director')
        Movie.create!(:id=>2, :title=>'Test movie2')
        
      end
      
      it 'should receive a call for find with director' do
        
        Movie.should_receive(:find_all_by_director)#.with('director')
        get :director, :id=>1, :name=>'director'
      end
      
      it 'should set an instance variable with movies' do
        assigns(:movies)
          get :director, :id=>1, :name=>'director'
      end
      
      it 'should render the directors view' do
          get :director, :id=>1, :name=>'director'
        response.should render_template('director')
        
      end
      
      it 'should render the movies view when no director is specified' do
        get :director, :id=>2
        response.should redirect_to(movies_path)
      end
      
    end
    
    
    describe 'get details for a movie' do
      before(:each) do
        Movie.create!(:id=>1, :title=>'Test movie', :director=>'director')
        get :show, :id=>1
      end
      
      it 'should render the movies view' do
        response.should render_template('show')
      end
      
      it 'should assign the movie variable' do
        assigns(:movie)
      end
      
      
    end
    
    
  
end
