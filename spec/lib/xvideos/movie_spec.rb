require "spec_helper"

describe Xvideos::Movie do
  context "when initialize valid params" do
    let(:params) do
      { page_url: "a", thumbnail_url: "a", description: "a",
        url: "a", duration: "a", quality: "a" }
    end

    it do
      expect(Xvideos::Movie.new(params)).to be_a_kind_of Xvideos::Movie
    end
  end

  context "when initialize invalid params" do
    let(:params) do
      { page_url: nil, thumbnail_url: "a", description: "a",
        url: "a", duration: "a", quality: "a" }
    end

    it do
      expect{ Xvideos::Movie.new(params) }.to raise_error
    end
  end
end
