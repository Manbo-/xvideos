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
    
    def to_a
      scrape
    end

    def each
      scrape.each do |hash|
        yield hash
      end
    end
    include Enumerable

    class << self
      def movies(http = TOP_PAGE, &block)
        Crawler::Movie.new(http, &block)
      end
      alias videos movies
      
      def tags(&block)
        Crawler::Tag.new(TAG_URL, &block)
      end

      def search(keyword, opts = {}, &block)
        page = opts.delete(:page)
        opts.merge!(p: page ? page - 1 : nil, k: keyword)
        query = URI.encode_www_form(opts)
        Crawler::Movie.new("#{TOP_PAGE}/?#{query}", &block)
      end
      alias find search
    end
  end
end

  
