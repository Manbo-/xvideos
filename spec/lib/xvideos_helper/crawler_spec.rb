require 'spec_helper'

describe "XvideosHelper::Crawler" do
  before do
    @crawler = XvideosHelper::Crawler.new
  end

  describe ".movies" do
    context "when default" do
      it do
        expect(@crawler.movies).to be_a_kind_of Array
      end

      it do
        expect(@crawler.movies).to be_empty
      end
    end
  end

  describe ".tags" do
    context "when default" do
      it do
        expect(@crawler.tags).to be_a_kind_of Array
      end

      it do
        expect(@crawler.tags).to be_empty
      end
    end
  end

  describe ".get_movies" do
    context "with valid" do
      it do
        expect{
          VCR.use_cassette "get_movies" do
            @crawler.get_movies
          end
        }.to change{ @crawler.movies.size }.from(0)
      end
    end

    context "with invalid" do
      it do
        expect{ @crawler.get_movies("invalid://hoge.fuga")}.to raise_error
      end
    end
  end

  describe ".get_tags" do
    it do
      expect{
        VCR.use_cassette "get_tags" do
          @crawler.get_tags
        end
      }.to change{ @crawler.tags.size }.from(0)
    end
  end
end
