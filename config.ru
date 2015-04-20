require 'bundler'
Bundler.require

require File.expand_path('../config/environment',  __FILE__)

Dir[File.join(File.dirname(__FILE__),"{lib,models}/**/*.rb")].each do |file|
  require file
end

run TrafficSpy::Server
