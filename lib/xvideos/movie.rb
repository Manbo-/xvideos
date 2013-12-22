module Xvideos
  class Movie < ::Hashie::Dash
    %i(page_url thumbnail_url description url duration quality).each do |name|
      property name, required: true
    end
  end
end
