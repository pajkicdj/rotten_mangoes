class MoviesController < ApplicationController
  
  def index
    if params[:runtime_in_minutes].nil?
      @movies = Movie.all.page(params[:page]).per(2)
    else
      #@movies = Movie.search(params[:search], params[:runtime_in_minutes]).page(params[:page]).per(2)
      @movies = Movie.search_movies(params[:search], params[:runtime_in_minutes]).page(params[:page]).per(2)
      #Kaminari.paginate_array(@movies).page(params[:page]).per(2)
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :description
    )
  end




end
