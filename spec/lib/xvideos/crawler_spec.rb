require 'spec_helper'

describe Xvideos::Crawler do
  describe ".movies" do
    it do
      expect(Xvideos::Crawler::Movie).to receive(:new)
      VCR.use_cassette "movies" do
        Xvideos::Crawler.movies
      end
    end

    it do
      user_agent_alias = "Windows IE 9"
      VCR.use_cassette "movies-windows-ie-9" do
        @crawler = Xvideos::Crawler.movies do |agent|
          agent.user_agent_alias = user_agent_alias
        end
      end
      expect(@crawler.instance_eval{ @agent.user_agent }).to eq Mechanize::AGENT_ALIASES[user_agent_alias]
    end
  end

  describe ".tags" do
    it do
      expect(Xvideos::Crawler::Tag).to receive(:new)
      VCR.use_cassette "tags" do
        Xvideos::Crawler.tags
      end
    end
  end

  describe ".search" do
    it do
      expect(Xvideos::Crawler::Movie).to receive(:new)
      VCR.use_cassette "search" do
        Xvideos::Crawler.search("porn")
      end
    end

    it do
      VCR.use_cassette "search-page-2" do
        @crawler = Xvideos::Crawler.search("porn", page: 2)
      end
      expect(@crawler.curr_page).to eq 2
    end
  end
end
