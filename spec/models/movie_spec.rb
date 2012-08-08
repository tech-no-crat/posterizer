require 'spec_helper'

describe Movie do
  before :each do
    @params = {:release => 1996, :title => "Test Movie", :tmdb_id => "4200420042", :url => "http://test.com/image.png"}
  end

  describe "validations" do
    it "accepts a valid movie" do
      m = Movie.new @params
      m.should be_valid
    end

    it "requires a title" do
      m = Movie.new @params.merge(:title => nil)
      m.should_not be_valid
    end

    it "rejects non-numeric release dates" do
      m = Movie.new @params.merge(:release => "bob")
      m.should_not be_valid
    end

    it "rejects invalid release dates" do
      m = Movie.new @params.merge(:release => -6)
      m.should_not be_valid
    end

    it "does not require a release date" do
      m = Movie.new(@params.merge(:release => nil))
      m.should be_valid
    end

    it "rejects extremely long titles" do
      m = Movie.new(@params.merge(:title => "a"*1000))
      m.should_not be_valid
    end

    it "requires a tmdb_id" do
      m = Movie.new(@params.merge(:tmdb_id => nil))
      m.should_not be_valid
    end

    it "rejects extremly long tmdb_ids" do
      m = Movie.new(@params.merge(:tmdb_id => "a" * 1000))
      m.should_not be_valid
    end

    it "should require a url" do
      m = Movie.new(@params.merge(:url => nil))
      m.should_not be_valid
    end

    it "should reject invalid urls" do
      m = Movie.new(@params.merge(:url => "bob"))
      m.should_not be_valid
    end
  end

  describe ".from_cache" do
    before :each do
      @ref = 'ijustmetyouandthisiscrazy'
    end

    it "should try retrieving the correct movie info from the cache" do
      CACHE.should_receive(:get).with(@ref)
      Movie.from_cache(@ref)
    end

    it "should return nil if the given ref does not exist in cache" do
      CACHE.stub(:get) { nil }
      Movie.from_cache(@ref).should be_nil
    end

    it "should try retrieving the correct movie" do
      CACHE.stub(:get) { @params.merge(:id => 42) }
      Movie.should_receive(:find_by_tmdb_id).with(42)
      Movie.from_cache @ref
    end

    it "it should create a new movie if the movie was not found" do
      CACHE.stub(:get) { @params.merge(:id => 42) }
      Movie.stub(:find_by_tmdb_id) { nil }
      m = mock_model(Movie)
      Movie.stub(:new) { m }
      m.should_receive(:save)
      Movie.from_cache @ref
    end

    it "should return the retrieved movie if one was found" do
      CACHE.stub(:get) { @params.merge(:id => 42) }
      m = mock_model(Movie)
      Movie.stub(:find_by_tmdb_id) { m }
      Movie.from_cache(@ref).should == m
    end
  end
end
