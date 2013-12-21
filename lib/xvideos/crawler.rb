require "xvideos/crawler/movie"
require "xvideos/crawler/tag"

module Xvideos
  class Crawler
    def initialize(http = nil, &block)
      @agent = Mechanize.new
      @agent.get(http) if http
      @agent.instance_eval(&block) if block_given?
    end

    def [](idx)
      scrape[idx]
    end
    
    def size
      scrape.size
    end
    alias length size
    alias count size
    
    def each
      scrape.each do |hash|
        yield hash
      end
    end
    include Enumerable

    class << self
      def movies(http = ENV::DOMAIN)
        @movies = Crawler::Movie.new(http)
      end
      alias videos movies
      
      def tags
        @tags = Crawler::Tag.new(ENV::TAG_URL)
      end
    end
  end
end

  
