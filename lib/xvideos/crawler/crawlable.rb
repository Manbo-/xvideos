module Xvideos::Crawler
  module Crawlable
    def initialize(http = nil, &block)
      @agent = Mechanize.new
      @agent.instance_eval(&block) if block_given?
      @agent.get(http) if http
    end

    def [](idx)
      scrape[idx]
    end
    
    def size
      scrape.size
    end
    alias length size
    alias count size
    
    def to_a
      scrape
    end

    def each
      scrape.each do |hash|
        yield hash
      end
    end
    include Enumerable
  end
end
