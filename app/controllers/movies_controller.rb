class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  before_action :load_ratings_and_sorting, only: [:index]

  # GET /movies or /movies.json
  def index
    @movies = Movie.where(rating: @selected_ratings)

    case @sort
    when 'title'
      @movies = @movies.order('title ASC')
    when 'release_date'
      @movies = @movies.order('release_date ASC')
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

    # Clean filter keeping sort and ratings state in session
    def load_ratings_and_sorting
      @all_ratings = Movie.all_ratings
      default_ratings = @all_ratings.index_with { "1" }

      # Sort handling
      session[:sort] = params[:sort] if params[:sort].present?
      @sort = session[:sort]

      # Ratings handling with session fallback
      if params[:ratings].present?
        session[:ratings] = params[:ratings].respond_to?(:to_unsafe_h) ? params[:ratings].to_unsafe_h : params[:ratings]
      elsif params[:commit].nil? && session[:ratings].blank?
        session[:ratings] = default_ratings
      end

      raw_ratings = params[:ratings] || session[:ratings] || default_ratings
      @selected_ratings_hash = raw_ratings.is_a?(ActionController::Parameters) ? raw_ratings.to_unsafe_h : raw_ratings
      @selected_ratings = @selected_ratings_hash.keys
    end
end