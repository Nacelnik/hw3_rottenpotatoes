class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    find_hash = Hash.new
    
    ratings = params[:ratings]
    
    if ratings
      @checked_ratings = ratings
      session[:ratings] = ratings
    else
      @checked_ratings = session[:ratings]
    end 
    
    
    if @checked_ratings 
      find_hash = {:conditions => "rating in (" }
      @checked_ratings.keys.each { |key|
        find_hash[:conditions] = find_hash[:conditions]+"'"+key.to_s+"', "
      }
      find_hash[:conditions] = find_hash[:conditions][0, find_hash[:conditions].length-2]+")"
    else
      @checked_ratings = []
    end
    
    flash[:notice] = @checked_ratings
    session[:ratings] = @checked_ratings
    
    if (params.has_key?(:sort_param))
      if (params[:sort_param] == "title")
        find_hash[:order] = "title ASC"
        #@movies = Movie.find(:order => "title ASC")
        @hilite = "title"
      elsif (params[:sort_param] == "date")
        find_hash[:order] = "release_date ASC"
        #@movies = Movie.find(:order => "release_date ASC")
        @hilite = "date"
      else
        flash[:notice] = "Unknown parameter to sort_by, exiting."  
      end  
    else
      @hilite = "none"
    end
    
    if (find_hash.keys.length != 0)
      @movies = Movie.all(find_hash)
   else
      @movies = Movie.all
    end
    #flash[:notice] = " delka klicu " + find_hash.keys.length.to_s + " "+find_hash[0].to_s
    
    @all_ratings = Movie.possible_ratings
    
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
