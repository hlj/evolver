require "spec_helper"

describe Evolver::Migration do

  describe ".file" do

    let(:caller) do
      "/some/dir/db/evolver/migrations/20120519113509_rename_bands_to_artists.rb:30"
    end

    it "returns the filename" do
      RenameBandsToArtists.file(caller).should eq(
        "20120519113509_rename_bands_to_artists.rb"
      )
    end
  end

  describe "#initialize" do

    let(:session) do
      Mongoid.default_session
    end

    let(:file) do
      "20120519113509_rename_bands_to_artists.rb"
    end

    let(:time) do
      Time.from_evolver_timestamp("20120519113509")
    end

    let(:migration) do
      RenameBandsToArtists.new(file, session, time)
    end

    it "sets the name of the file" do
      migration.file.should eq(file)
    end

    it "sets the session" do
      migration.session.should eq(session)
    end

    it "sets the timestamp" do
      migration.time.should eq(time)
    end
  end

  describe "#mark_as_executed" do

    let(:session) do
      Mongoid.default_session
    end

    let(:file) do
      "20120519113509_rename_bands_to_artists.rb"
    end

    let(:time) do
      Time.from_evolver_timestamp("20120519113509")
    end

    let(:migration) do
      RenameBandsToArtists.new(file, session, time)
    end

    before do
      session.use :evolver
      migration.mark_as_executed
    end

    let(:stored) do
      session[:evolver_migrations].find.first
    end

    after do
      session[:evolver_migrations].drop
    end

    it "inserts the file name" do
      stored["file"].should eq(file)
    end

    it "inserts the generated time" do
      stored["generated"].should eq(time)
    end

    it "inserts the executed time" do
      stored["executed"].should be_within(1).of(Time.now)
    end

    it "inserts the migration name" do
      stored["migration"].should eq("RenameBandsToArtists")
    end
  end

  describe ".sessions" do

    context "when provided a single session" do

      let(:registry) do
        Evolver.registry.fetch("RenameBandsToArtists")
      end

      it "adds the migration to the session" do
        registry.should eq({
          file: "20120519113509_rename_bands_to_artists.rb",
          time: Time.from_evolver_timestamp("20120519113509"),
          sessions: [ :default ]
        })
      end
    end
  end

  describe ".time" do

    let(:caller) do
      "/some/dir/db/evolver/migrations/20120519113509_rename_bands_to_artists.rb:30"
    end

    it "returns the timestamp" do
      RenameBandsToArtists.time(caller).should eq(
        Time.from_evolver_timestamp("20120519113509")
      )
    end
  end
end
