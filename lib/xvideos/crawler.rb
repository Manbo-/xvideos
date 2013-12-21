require "xvideos/crawler/movie"
require "xvideos/crawler/tag"

module Xvideos
  class Crawler
    TOP_PAGE   = 'http://jp.xvideos.com'
    TAG_URL    = "#{TOP_PAGE}/tags"
    IFRAME_URL = 'http://flashservice.xvideos.com/embedframe/'

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
    
    def each
      scrape.each do |hash|
        yield hash
      end
    end
    include Enumerable

    class << self
      def movies(http = TOP_PAGE, &block)
        @movies = Crawler::Movie.new(http, &block)
      end
      alias videos movies
      
      def tags(&block)
        @tags = Crawler::Tag.new(TAG_URL, &block)
      end
    end
  end
end

  
