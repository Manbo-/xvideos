module Xvideos
  class Tag < Hashie::Dash
    %i(name url count).each do |name|
      property name, required: true
    end
    
    def movies(&block)
      Xvideos::Crawler.movies(url, &block)
    end
  end
end
