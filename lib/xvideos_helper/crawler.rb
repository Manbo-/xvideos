# coding: utf-8
require "mechanize"

module XvideosHelper
  class Crawler
    attr_accessor :movies_limit,:tags_limit
    def initialize
      @movies_limit ||= -1
      @tags_limit ||= -1

      @agent = Mechanize.new
    end

    def get_data_from(url,from)
      @agent.get(url)
      case from
      when "movie"   then parsed_movie_data
      when "taglist" then parsed_tag_data
      else
        {}
      end
    rescue Exception => e
      raise e
    end

    private

    # main crawler
    def parsed_movie_data
      parsed_data = initialized_hash
      @agent.page.search('//div[@class="thumbBlock"]/div[@class="thumbInside"]').each_with_index do |post, index|
        movie_page_url, movie_thumnail_url, description = nil
        duration, movie_quality = nil
        # limit
        break if @movies_limit == index

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
        parsed_data[index] = {"movie_page_url" => movie_page_url, "movie_thumnail_url" => movie_thumnail_url,
          "description" => description, "movie_url" => movie_url, "duration" => duration, "movie_quality" => movie_quality }
      end
      parsed_data
    rescue Exception => e
      raise e
    end

    # tag list crawler
    def parsed_tag_data
      parsed_data = initialized_hash
      @agent.page.search('//div[@id="main"]/ul[@id="tags"]/li').each_with_index do |li, index|
        # limit
        break if @tags_limit == index
        # tag info
        tag_name = li.children.children.inner_text
        tag_url = URI.join(ENV::DOMAIN, li.at("a")[:href]).to_s
        tag_count = li.inner_text.sub(/.+\s/,'')
        parsed_data[index] = {"tag_name" => tag_name, "tag_url" => tag_url, "tag_count" => tag_count}
      end
      parsed_data
    rescue Exception => e
      raise e
    end

    def initialized_hash
      Hash.new{ |hash, key| hash[key] = {} }
    end
  end
end
