require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:runtime, :test)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'spec'
require 'ronin/ext/version'

include Ronin
