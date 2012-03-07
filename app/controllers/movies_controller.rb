class MoviesController < ApplicationController

  

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    #@all_ratings = Movie.getPossibleRatings
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    if (params.has_key?(:sort_param))
      if (params[:sort_param] == "title")
        @movies = Movie.all(:order => "title ASC")
        @hilite = "title"
      elsif (params[:sort_param] == "date")
        @movies = Movie.all(:order => "release_date ASC")
        @hilite = "date"
      else
        flash[:notice] = "Unknown parameter to sort_by, exiting."  
      end  
    else
      @movies = Movie.all
      @hilite = "none"
    end
  end

  def new
    # default: render 'new' template
  end


  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
