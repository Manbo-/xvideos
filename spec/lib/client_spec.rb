require 'spec_helper'

describe "XvideosHelper::Client" do
  before do
    @xh = XvideosHelper::Client.new
  end

  describe '.movies_of' do
    context "with valid value" do
      before do
        VCR.use_cassette("client_movies_of_with_valid_value") do
          @lists = @xh.movies_of("http://jp.xvideos.com/")
        end
      end

      it 'return valid values' do
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

    context 'with invalid value' do
      it 'raises error' do
        expect{ @xh.movies_of("invalid://jp.xvideos.com/") }.to raise_error
      end
    end
  end
    

  describe '.tag_data_lists' do
    context "with valid value" do 
      before do
        VCR.use_cassette("client_tag_data_lists_with_valid_value") do
          @tag_data_lists = @xh.tag_data_lists
        end
      end

      it 'return valid values' do
        expect(@tag_data_lists.count).to be > 0
        @tag_data_lists.each do |key,list|
          expect(list['tag_name']).to_not be_nil
          expect(list['tag_url']).to match(/^http:\/\/.+/)
          expect(list['tag_count']).to_not be_nil
        end
      end
    end

    context "with invalid value" do
      it 'raises error' do
        @xh.tag_url = 'aaaaaaaa'
        expect{ @xh.tag_data_lists }.to raise_error
      end
    end
  end

  describe '.movies_limit=' do
    context "with limit 1" do
      before do
        @xh.movies_limit = 1
        VCR.use_cassette("client_movies_of_with_limit") do
          @lists = @xh.movies_of("http://jp.xvideos.com/")
        end
      end

      it 'changes limit to 1' do
        expect(@lists.count).to eq 1
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

    context "with limit 0" do
      before do
        @xh.movies_limit = 0
        VCR.use_cassette("client_movies_of_with_limit") do
          @lists = @xh.movies_of("http://jp.xvideos.com/")
        end
      end
      
      it 'changes limit to 0' do
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

  describe '.tags_limit=' do
    context "with limit 0" do
      before do
        @xh.tags_limit = 0
        VCR.use_cassette("client_tag_data_lists") do
          @tag_data_lists = @xh.tag_data_lists
        end
      end

      it do
        expect(@tag_data_lists.count).to eq 0
        @tag_data_lists.each do |key,list|
          expect(list['tag_name']).to_not be_nil
          expect(list['tag_url']).to match(/^http:\/\/.+/)
          expect(list['tag_count']).to_not be_nil
        end
      end
    end

    context "with limit 1" do
      before do
        @xh.tags_limit = 1
        VCR.use_cassette("client_tag_data_lists") do
          @tag_data_lists = @xh.tag_data_lists
        end
      end

      it do
        expect(@tag_data_lists.count).to eq 1
        @tag_data_lists.each do |key,list|
          expect(list['tag_name']).to_not be_nil
          expect(list['tag_url']).to match(/^http:\/\/.+/)
          expect(list['tag_count']).to_not be_nil
        end
      end
    end
  end
end
