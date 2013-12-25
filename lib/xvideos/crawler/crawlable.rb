module Xvideos::Crawler
  module Crawlable
    def initialize(http = nil, &block)
      @agent = Mechanize.new
      @agent.instance_eval(&block) if block_given?
      @agent.get(http) if http
    end

    def to_a
      scrape
    end
  end
end
