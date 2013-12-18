# coding: utf-8
require "mechanize"

module XvideosHelper
  class Crawler
    def initialize
      @agent = Mechanize.new
      @movies, @tags = [], []
    end

    attr_reader :movies, :tags
    alias videos movies

    def get_movies(url = ENV::DOMAIN)
      @agent.get(url)
      @movies = scrape_movie_data
    end
    alias get_videos get_movies

    def get_tags
      @agent.get(ENV::TAG_URL)
      @tags = scrape_tag_data
    end

    private

    def scrape_movie_data
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
    rescue Exception => e
      raise e
    end

    def scrape_tag_data
      @agent.page.search('//div[@id="main"]/ul[@id="tags"]/li').map do |li|
        # tag info
        tag_name = li.children.children.inner_text
        tag_url = URI.join(ENV::DOMAIN, li.at("a")[:href]).to_s
        tag_count = li.inner_text.sub(/.+\s/,'')
        {"tag_name" => tag_name, "tag_url" => tag_url, "tag_count" => tag_count}
      end
    rescue Exception => e
      raise e
    end
  end
end
