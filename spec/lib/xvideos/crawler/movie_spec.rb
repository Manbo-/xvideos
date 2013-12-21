require "spec_helper"

describe Xvideos::Crawler::Movie do
  context "when page 1" do
    let(:crawler) do
      VCR.use_cassette "page-1-home-1" do
        Xvideos::Crawler::Movie.new(Xvideos::Crawler::TOP_PAGE)
      end
    end

    it_should_behave_like "an array" do
      let(:array){ crawler }
    end
    
    it do
      expect(crawler.curr_page).to eq 1
    end

    describe "#next_page" do
      it do
        expect(crawler.next_page).to match URI.regexp
      end

      it do
        expect(crawler.next_page?).to be_true
      end

      it do
        expect{
          VCR.use_cassette "page-1-home-2" do
            crawler.next_page!
          end
        }.to change{ crawler.curr_page }.from(1).to(2)
      end
    end

    describe "#prev_page" do
      it do
        expect(crawler.prev_page).to be_nil
      end

      it do
        expect(crawler.prev_page?).to be_false
      end

      it do
        expect{ crawler.prev_page! }.to raise_error
      end
    end
  end

  context "when page 2" do
    let(:crawler) do
      VCR.use_cassette "page-2-home-2" do
        Xvideos::Crawler::Movie.new(URI.join(Xvideos::Crawler::TOP_PAGE, "/home/1"))
      end
    end

    it do
      expect(crawler.curr_page).to eq 2
    end

    describe "#next_page" do
      it do
        expect(crawler.next_page).to match URI.regexp
      end

      it do
        expect(crawler.next_page?).to be_true
      end

      it do
        expect{
          VCR.use_cassette "page-2-home-3" do
            crawler.next_page!
          end
        }.to change{ crawler.curr_page }.from(2).to(3)
      end
    end

    describe "#prev_page" do
      it do
        expect(crawler.prev_page).to match URI.regexp
      end

      it do
        expect(crawler.prev_page?).to be_true
      end

      it do
        expect{
          VCR.use_cassette "page-2-home-1" do
            crawler.prev_page!
          end
        }.to change{ crawler.curr_page }.from(2).to(1)
      end
    end
  end
end
