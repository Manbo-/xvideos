require "spec_helper"

describe Xvideos::Crawler::Tag do
  let(:crawler) do
    VCR.use_cassette "tag" do
      Xvideos::Crawler::Tag.new(Xvideos::ENV::TAG_URL)
    end
  end

  it_should_behave_like "an array" do
    let(:array){ crawler }
  end
end
