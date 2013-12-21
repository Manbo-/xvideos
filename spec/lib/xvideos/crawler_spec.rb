require 'spec_helper'

describe Xvideos::Crawler do
  describe ".movies" do
    it do
      expect(Xvideos::Crawler::Movie).to receive(:new)
      VCR.use_cassette ".movies" do
        Xvideos::Crawler.movies
      end
    end
  end

  describe ".tags" do
    it do
      expect(Xvideos::Crawler::Tag).to receive(:new)
      VCR.use_cassette ".tags" do
        Xvideos::Crawler.tags
      end
    end
  end
end
