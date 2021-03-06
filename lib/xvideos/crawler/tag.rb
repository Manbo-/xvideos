require "xvideos/crawler/crawlable"

module Xvideos
  module Crawler
    class Tag
      include Crawlable

      alias tags to_a

      private

      def scrape
        @agent.page.search('//div[@id="main"]/ul[@id="tags"]/li').map do |li|
          # tag info
          name = li.children.children.inner_text
          url = URI.join(TOP_PAGE, li.at("a")[:href]).to_s
          count = li.inner_text.sub(/.+\s/,'')
          Xvideos::Tag.new(name: name, url: url, count: count)
        end
      end
    end
  end
end

