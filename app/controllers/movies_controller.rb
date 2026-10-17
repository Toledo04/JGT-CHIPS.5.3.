class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  before_action :load_ratings_and_sorting, only: [:index]

  # GET /movies or /movies.json
  def index
    @movies = Movie.with_ratings(@selected_ratings)

    case @sort_by
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

    def load_ratings_and_sorting
      @all_ratings = Movie.all_ratings
      default_ratings_hash = @all_ratings.index_with { "1" }

      # 1. Sorting handling
      sort_param = params[:sort_by] || params[:sort]
      if sort_param.present?
        session[:sort_by] = sort_param
      end
      @sort_by = session[:sort_by]
      @sort = @sort_by

      # 2. Ratings handling
      if params[:ratings].present?
        ratings = params[:ratings]
        ratings = ratings.to_unsafe_h if ratings.respond_to?(:to_unsafe_h)
        session[:ratings] = ratings
      elsif params[:commit].present? && params[:ratings].blank?
        session[:ratings] = default_ratings_hash
      else
        session[:ratings] ||= default_ratings_hash
      end

      # 3. Normalize ratings
      raw_ratings = session[:ratings] || default_ratings_hash
      if raw_ratings.is_a?(Hash) || raw_ratings.is_a?(ActionController::Parameters)
        @selected_ratings_hash = raw_ratings.to_h
        @selected_ratings = @selected_ratings_hash.keys
      elsif raw_ratings.is_a?(Array)
        @selected_ratings = raw_ratings
        @selected_ratings_hash = @selected_ratings.index_with { "1" }
      else
        @selected_ratings = @all_ratings
        @selected_ratings_hash = default_ratings_hash
      end

      @ratings_to_show = @selected_ratings
    end
end