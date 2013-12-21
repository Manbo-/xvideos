$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'xvideos'

require "pry"
require "webmock"
require "vcr"

Dir["./spec/support/**/*.rb"].each { |f| require f}

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end
