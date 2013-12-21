require "xvideos/crawler/movie"
require "xvideos/crawler/tag"

module Xvideos
  class Crawler
    TOP_PAGE   = 'http://jp.xvideos.com'
    TAG_URL    = "#{TOP_PAGE}/tags"
    IFRAME_URL = 'http://flashservice.xvideos.com/embedframe/'

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
      def movies(http = TOP_PAGE)
        @movies = Crawler::Movie.new(http)
      end
      alias videos movies
      
      def tags
        @tags = Crawler::Tag.new(TAG_URL)
      end
    end
  end
end

  
