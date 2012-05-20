require "spec_helper"

describe Evolver do

  describe ".find" do

    let(:session) do
      Moped::Session.new([ "localhost:27017" ])
    end

    context "when the migration exists" do

      let(:found) do
        described_class.find("RenameBandsToArtists", session)
      end

      it "returns the migration instance" do
        found.file.should eq("20120519113509-rename_bands_to_artists.rb")
      end
    end

    context "when the migration does not exist" do

      it "raises an error" do
        expect {
          described_class.find("Test", session)
        }.to raise_error
      end
    end
  end

  describe ".registry" do

    let(:registry) do
      described_class.registry
    end

    it "returns the registry hash" do
      registry["RenameBandsToArtists"].should_not be_empty
    end
  end

  describe ".register" do

    before do
      described_class.register("MoveSomeData", "test.rb", Time.now, [ :default ])
    end

    after do
      described_class.registry.delete("MoveSomeData")
    end

    it "adds the migration metadata to the registry" do
      described_class.registry["MoveSomeData"].should_not be_nil
    end
  end
end
