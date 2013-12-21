module XvideosHelper
  class Crawler
    class Tag < Crawler
      
      private

      def scrape_tags
        @doc.search('//div[@id="main"]/ul[@id="tags"]/li').map do |li|
          # tag info
          tag_name = li.children.children.inner_text
          tag_url = URI.join(ENV::DOMAIN, li.at("a")[:href]).to_s
          tag_count = li.inner_text.sub(/.+\s/,'')
          {"tag_name" => tag_name, "tag_url" => tag_url, "tag_count" => tag_count}
        end
      end
    end
  end
end
