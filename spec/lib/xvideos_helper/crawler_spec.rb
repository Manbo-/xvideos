require 'spec_helper'

describe XvideosHelper::Crawler do
  before do
    @crawler = XvideosHelper::Crawler.new
  end

  describe ".movies" do
    it do
      expect(XvideosHelper::Crawler::Movie).to receive(:new)
      VCR.use_cassette ".movies" do
        @crawler.movies
      end
    end
  end

  describe ".tags" do
    it do
      expect(XvideosHelper::Crawler::Tag).to receive(:new)
      VCR.use_cassette ".tags" do
        @crawler.tags
      end
    end
  end
end
