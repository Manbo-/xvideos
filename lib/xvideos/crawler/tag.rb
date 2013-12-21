module Xvideos
  class Crawler
    class Tag < Crawler
      private

      def scrape
        @agent.page.search('//div[@id="main"]/ul[@id="tags"]/li').map do |li|
          # tag info
          name = li.children.children.inner_text
          url = URI.join(ENV::DOMAIN, li.at("a")[:href]).to_s
          count = li.inner_text.sub(/.+\s/,'')
          { name: name, url: url, count: count }
        end
      end
    end
  end
end
