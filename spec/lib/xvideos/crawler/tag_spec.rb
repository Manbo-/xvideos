require "spec_helper"

describe Xvideos::Crawler::Tag do
  let(:crawler) do
    VCR.use_cassette "tag" do
      Xvideos::Crawler::Tag.new(Xvideos::Crawler::TAG_URL)
    end
  end

  it do
    expect(crawler.tags).to be_a_kind_of Array
  end

  it do
    expect(crawler.tags).to be_all{ |tag| tag.is_a? Xvideos::Tag }
  end
end
