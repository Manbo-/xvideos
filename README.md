# Xvideos

Xvideos is a gem to support for adult site creater.This gem provides xvideo's data like movie url or movie page url for you with scraping the site easily.

## Example

### movies
    crawler = Xvideos::Crawler.movies # => Xvideos::Crawler::Movie
    crawler.each do |movie|
      movie[:url]
      movie[:page_url]
      movie[:thumbnail_url]
      movie[:description]
      movie[:duration]
      movie[:quality]
    end
    crawler.next_page! if crawler.next_page?
    crawler.each do |movie|
      ...
    end

### tags
    crawler = Xvideos::Crawler.tags # => Xvideos::Crawler::Tag
    crawler.each do |tag|
      tag[:name]
      tag[:url]
      tag[:count]
    end

### initialize with block
    crawler = Xvideos::Crawler.movies do |agent|
       agent # => Mechanize
       agent.user_agent_alais = "Windows IE 9"
    end

## Command
    $ xvideos movies [url]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
