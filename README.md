# Xvideos

[![Build Status](https://travis-ci.org/Manbo-/xvideos.png)](https://travis-ci.org/Manbo-/xvideos)

## Install
    $ git clone https://github.com/Manbo-/xvideos.git
    $ cd ./xvideos
    $ rake install

## Usage

### movies
    crawler = Xvideos::Crawler.movies # => Xvideos::Crawler::Movie
    crawler.movies # => Array
    crawler.movies.each do |movie|
      movie # => Xvideos::Movie
      movie.url
      movie.page_url
      movie.thumbnail_url
      movie.description
      movie.duration
      movie.quality
    end
    crawler.next_page! if crawler.next_page?
    crawler.movies.each do |movie|
      ...
    end

### tags
    crawler = Xvideos::Crawler.tags # => Xvideos::Crawler::Tag
    crawler.tags # => Array
    crawler.tags.each do |tag|
      tag # => Xvideos::Tag
      tag.name
      tag.url
      tag.count
      tag.movies # => Xvideos::Crawler::Movie
    end

### search
    crawler = Xvideos::Crawler.search(keyword, page: 3) # => Xvideos::Crawler::Movie

### call with block
    crawler = Xvideos::Crawler.movies do |agent|
       agent # => Mechanize
       agent.user_agent_alias = "Windows IE 9"
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
