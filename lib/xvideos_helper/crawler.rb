require "xvideos_helper/crawler/movie"
require "xvideos_helper/crawler/tag"

module XvideosHelper
  class Crawler
    def initialize(http = nil, &block)
      @agent = Mechanize.new
      @agent.get(http) if http
      @agent.instance_eval(&block) if block_given?
    end

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

  
