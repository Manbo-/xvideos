require 'spec_helper'

describe XvideosHelper::Crawler do
  describe ".movies" do
    it do
      expect(XvideosHelper::Crawler::Movie).to receive(:new)
      VCR.use_cassette ".movies" do
        XvideoHelper::Crawler.movies
      end
    end
  end

  describe ".tags" do
    it do
      expect(XvideosHelper::Crawler::Tag).to receive(:new)
      VCR.use_cassette ".tags" do
        XvideoHelper::Crawler.tags
      end
    end
  end
end
