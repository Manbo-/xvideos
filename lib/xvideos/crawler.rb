require "xvideos/crawler/crawlable"
require "xvideos/crawler/movie"
require "xvideos/crawler/tag"

module Xvideos
  module Crawler
    TOP_PAGE   = 'http://jp.xvideos.com'
    TAG_URL    = "#{TOP_PAGE}/tags"
    IFRAME_URL = 'http://flashservice.xvideos.com/embedframe/'

    module_function

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

  
