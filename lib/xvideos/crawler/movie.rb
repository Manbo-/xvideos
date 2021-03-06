require "xvideos/crawler/crawlable"

module Xvideos
  module Crawler
    class Movie
      include Crawlable

      alias movies to_a

      def curr_page
        scrape_pages[:curr_page]
      end
      alias current_page curr_page

      %i(next_page prev_page).each do |method_name|
        define_method method_name do
          if a = scrape_pages[method_name]
            URI.join(TOP_PAGE, a[:href]).to_s
          end
        end

        define_method "#{method_name}?" do
          !!scrape_pages[method_name]
        end

        define_method "#{method_name}!" do
          @agent.get(send(method_name))
        end
      end

      private

      def scrape_pages
        xpath = "//div[contains(concat(' ' ,@class, ' '), ' pagination ')]/ul/li/a"
        pages = @agent.page.search(xpath)
        c = pages.find{ |a| a[:class] == "sel" }.inner_text.to_i
        n = pages[c]
        p = c - 2 >= 0  ? pages[c - 2] : nil
        { curr_page: c, next_page: n, prev_page: p }
      end

      def scrape
        @agent.page.search('//div[@class="thumbBlock"]/div[@class="thumbInside"]').map do |post|
          page_url, thumbnail_url, description, duration, quality = nil

          # thumbnail infomation
          post.search('div[@class="thumb"]/a').each do |a|
            page_url      = URI.join(TOP_PAGE, a[:href]).to_s
            thumbnail_url = a.at("img")[:src]
          end

          # if script tag is contained
          post.search('script').each do |elm|
            href          = elm.children[0].content.match(/href="(.+?)">/)[1]
            page_url      = URI.join(TOP_PAGE, href).to_s
            thumbnail_url = elm.children[0].content.match(/src="(.+?)"/)[1]
            description   = elm.children[0].content.match(/<p><a href=".+">(.+)<\/a><\/p>/)[1]
          end

          # iframe url
          iframe = page_url.match(/\/video(\d+)\/.*/)[1]
          url    = URI.join(IFRAME_URL, iframe).to_s

          # description
          post.search('p/a').each do |a|
            description = a.inner_text
          end

          # metadata
          post.search('p[@class="metadata"]/span[@class="bg"]').each do |span|
            text     = span.inner_text.gsub(/(\t|\s|\n)+/,'')
            duration = text.match(/\(.+\)/)[0]
            quality  = text.sub(/\(.+\)/,'')
          end
          Xvideos::Movie.new(page_url: page_url, thumbnail_url: thumbnail_url,
                             description: description, url: url, duration: duration, quality: quality)
        end
      end
    end
  end
end
