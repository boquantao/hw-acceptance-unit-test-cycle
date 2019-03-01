require 'simplecov'
SimpleCov.start 'rails'
require 'rails_helper'

describe MoviesController, type: :controller do
    describe "#director" do
        context "When the movie has a director" do
            it "should find all movies with the same director" do
                @movie_id = '1'
                @movie = double(:title => 'Inception', :director => 'Christopher Nolan')

                expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)
                expect(Movie).to receive(:same_director).with('Christopher Nolan')

                get :director, {:id => @movie_id}
                expect(response).to render_template(:director)
            end
        end

        context "When the movie has no director" do
            it "should redirect to the movies page" do
                @movie_id = "1"
                @movie = double(:title => 'fake_test_movie').as_null_object
                expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)
                get :director, :id => @movie_id
                expect(response).to redirect_to(movies_path)
            end
        end

    end

    describe "#sort" do
        context "When sort by title" do
            it "should sort all movies by title" do
                get :index, :sort => :title, :ratings => ["R","PG", "G"]
            end
        end
        context "When sort by release_date" do
            it "should sort all movies by release_date" do
                get :index, :sort => :release_date, :ratings => ["G", "PG", "PG-13"]
            end
        end
    end

    describe "#new" do
        context "When create a movie" do
            it "should create it to database" do
                movie_new = Hash.new
                movie_new["title"] = "Movie_new"
                movie_new["rating"] = "G"
                movie_new["director"] = "Director_new"
                movie_new["release_date"] = Date.new(2000, 1, 1)

                post :create, movie: movie_new
                expect(response).to redirect_to("/movies")
            end
        end
    end
end
