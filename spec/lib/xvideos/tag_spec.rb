require "spec_helper"

describe Xvideos::Tag do
  context "when initialize valid params" do
    let(:params) do
      { name: "a", url: "http://www.xvideos.com/tags/18", count: "a" }
    end

    it do
      expect(Xvideos::Tag.new(params)).to be_a_kind_of Xvideos::Tag
    end

    it do
      VCR.use_cassette "tag-movies" do
        @movies = Xvideos::Tag.new(params).movies
      end
      expect(@movies).to be_a_kind_of Xvideos::Crawler::Movie
    end

    it do
      expect_any_instance_of(Mechanize).to receive(:get).with(params[:url])
      VCR.use_cassette "tag-movies" do
        @movies = Xvideos::Tag.new(params).movies
      end
    end
  end

  context "when initialize invalid params" do
    let(:params) do
      { name: nil, url: "a", count: "a" }
    end

    it do
      expect{ Xvideos::Tag.new(params) }.to raise_error
    end
  end
end
