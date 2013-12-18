require 'spec_helper'

describe "XvideosHelper::Crawler" do
  before do
    @xh = XvideosHelper::Crawler.new
  end

  describe '.get_data_from' do
    context "when movie" do
      context do
        before do
          VCR.use_cassette "crawler_get_data_from_movie" do
            @lists = @xh.get_data_from("http://jp.xvideos.com/",'movie')
          end
        end

        it 'return valid movie information' do
          expect(@lists.count).to be > 0
          @lists.each do |key,list|
            expect(list["movie_url"]).to match(/^http:\/\/.+\/\d+$/)
            expect(list["movie_page_url"]).to match(/^http:\/\/.+/)
            expect(list["movie_thumnail_url"]).to match(/^http:\/\/.+/)
            expect(list["description"]).to_not be_nil
            expect(list["duration"]).to_not be_nil
            expect(list["movie_quality"]).to_not be_nil
          end
        end
      end

      context "with limit" do
        before do
          @xh.movies_limit = 0
          VCR.use_cassette "crawler_get_data_from_movie_with_limit" do
            @lists = @xh.get_data_from("http://jp.xvideos.com/",'movie')
          end
        end
        
        it 'return 0 movie information' do
          expect(@lists.count).to eq 0
          @lists.each do |key,list|
            expect(list["movie_url"]).to match(/^http:\/\/.+\/\d+$/)
            expect(list["movie_page_url"]).to match(/^http:\/\/.+/)
            expect(list["movie_thumnail_url"]).to match(/^http:\/\/.+/)
            expect(list["description"]).to_not be_nil
            expect(list["duration"]).to_not be_nil
            expect(list["movie_quality"]).to_not be_nil
          end
        end
      end
    end

    describe "taglist" do
      context do
        before do
          VCR.use_cassette "crawler_get_data_from_taglist" do
            @lists = @xh.get_data_from("http://jp.xvideos.com/tags",'taglist')
          end
        end

        it 'return valid tag lists' do
          expect(@lists.count).to be > 0
          @lists.each do |key,list|
            expect(list['tag_name']).to_not be_nil
            expect(list['tag_url']).to match(/^http:\/\/.+/)
            expect(list['tag_count']).to_not be_nil
          end
        end
      end

      context "with limit" do
        it 'return 0 tag list' do
          @xh.tags_limit = 0
          VCR.use_cassette "crawler_get_data_from_taglist_with_limit" do
            @lists = @xh.get_data_from("http://jp.xvideos.com/tags",'taglist')
          end
          expect(@lists.count).to eq 0
          @lists.each do |key,list|
            expect(list['tag_name']).to_not be_nil
            expect(list['tag_url']).to match(/^http:\/\/.+/)
            expect(list['tag_count']).to_not be_nil
          end
        end
      end
    end
  end

  context "with undifined name or the other objects" do
    it 'return empty object' do
      VCR.use_cassette "crawler_get_data_from_taglist_with_undefined_name" do
        @lists = @xh.get_data_from("http://jp.xvideos.com/",'undifined_name')
      end
      expect(@lists).to eq({})
      VCR.use_cassette "crawler_get_data_from_taglist_with_empty_hash" do
        @lists = @xh.get_data_from("http://jp.xvideos.com/",{})
      end
      expect(@lists).to eq({})
      VCR.use_cassette "crawler_get_data_from_taglist_with_empty_array" do
        @lists = @xh.get_data_from("http://jp.xvideos.com/",[])
      end
      expect(@lists).to eq({})
    end
  end

  it 'raises error if invalid url' do
    expect{ @xh.movies_of("invalid://jp.xvideos.com/",'movie') }.to raise_error
  end
end
