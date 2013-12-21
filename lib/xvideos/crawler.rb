require "xvideos/crawler/movie"
require "xvideos/crawler/tag"

module Xvideos
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

  
