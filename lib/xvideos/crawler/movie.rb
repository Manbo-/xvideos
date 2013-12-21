module Xvideos
  class Crawler
    class Movie < Crawler
      def [](idx)
        scrape_movies[idx]
      end

      def size
        scrape_movies.size
      end
      alias length size
      alias count size

      def each
        scrape_movies.each do |movie|
          yield movie
        end
      end

      include Enumerable

      def curr_page
        scrape_pages[:curr_page]
      end
      alias current_page curr_page

      %i(next_page prev_page).each do |method_name|
        define_method method_name do
          if a = scrape_pages[method_name]
            URI.join(ENV::DOMAIN, a[:href]).to_s
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
        pages = @agent.page.search("//div[@class='pagination']/ul/li/a")
        c = pages.find{ |a| a[:class] == "sel" }.inner_text.to_i
        n = pages[c]
        p = c - 2 >= 0  ? pages[c - 2] : nil
        { curr_page: c, next_page: n, prev_page: p }
      end

      def scrape_movies
        @agent.page.search('//div[@class="thumbBlock"]/div[@class="thumbInside"]').map do |post|
          movie_page_url, movie_thumnail_url, description = nil
          duration, movie_quality = nil

          # thumbnail infomation
          post.search('div[@class="thumb"]/a').each do |a|
            movie_page_url     = URI.join(ENV::DOMAIN, a[:href]).to_s
            movie_thumnail_url = a.at("img")[:src]
          end

          # if script tag is contained
          post.search('script').each do |elm|
            href = elm.children[0].content.match(/href="(.+?)">/)[1]
            movie_page_url     = URI.join(ENV::DOMAIN, href).to_s
            movie_thumnail_url = elm.children[0].content.match(/src="(.+?)"/)[1]
            description        = elm.children[0].content.match(/<p><a href=".+">(.+)<\/a><\/p>/)[1]
          end

          # iframe url
          iframe = movie_page_url.match(/\/video(\d+)\/.*/)[1]
          movie_url = URI.join(ENV::IFRAME_URL, iframe).to_s

          # description
          post.search('p/a').each do |a|
            description = a.inner_text
          end

          # metadata
          post.search('p[@class="metadata"]/span[@class="bg"]').each do |span|
            text = span.inner_text.gsub(/(\t|\s|\n)+/,'')
            duration = text.match(/\(.+\)/)[0]
            movie_quality = text.sub(/\(.+\)/,'')
          end
          {"movie_page_url" => movie_page_url, "movie_thumnail_url" => movie_thumnail_url,
            "description" => description, "movie_url" => movie_url, "duration" => duration,
            "movie_quality" => movie_quality }
        end
      end
    end
  end
end
