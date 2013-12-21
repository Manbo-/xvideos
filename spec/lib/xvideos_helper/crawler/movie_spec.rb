require "spec_helper"

describe XvideosHelper::Crawler::Movie do
  context "when page 1" do
    before do
      VCR.use_cassette "page-1home-1" do
        @cralwer = XvideosHelper::Crawler::Movie.new(XvideosHelper::ENV::DOMAIN)
      end
    end

    it do
      expect(@cralwer.curr_page).to eq 1
    end

    describe ".next_page" do
      it do
        expect(@cralwer.next_page).to match URI.regexp
      end

      it do
        expect(@cralwer.next_page?).to be_true
      end

      it do
        expect{
          VCR.use_cassette "page-1-home-2" do
            @cralwer.next_page!
          end
        }.to change{ @cralwer.curr_page }.from(1).to(2)
      end
    end

    describe ".prev_page" do
      it do
        expect(@cralwer.prev_page).to be_nil
      end

      it do
        expect(@cralwer.prev_page?).to be_false
      end

      it do
        expect{ @cralwer.prev_page! }.to raise_error
      end
    end
  end

  context "when page 2" do
    before do
      VCR.use_cassette "page-2-home-2" do
        @cralwer = XvideosHelper::Crawler::Movie.new(URI.join(XvideosHelper::ENV::DOMAIN, "/home/1"))
      end
    end

    it do
      expect(@cralwer.curr_page).to eq 2
    end

    describe ".next_page" do
      it do
        expect(@cralwer.next_page).to match URI.regexp
      end

      it do
        expect(@cralwer.next_page?).to be_true
      end

      it do
        expect{
          VCR.use_cassette "page-2-home-3" do
            @cralwer.next_page!
          end
        }.to change{ @cralwer.curr_page }.from(2).to(3)
      end
    end

    describe ".prev_page" do
      it do
        expect(@cralwer.prev_page).to match URI.regexp
      end

      it do
        expect(@cralwer.prev_page?).to be_true
      end

      it do
        expect{
          VCR.use_cassette "page-2-home-1" do
            @cralwer.prev_page!
          end
        }.to change{ @cralwer.curr_page }.from(2).to(1)
      end
    end
  end
end
