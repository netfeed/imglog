require 'bundler'

Bundler.require

require 'sinatra/sequel'
require 'yaml'

mode = development? ? 'development' : 'production'
file = File.join(File.dirname(__FILE__), 'config', "#{mode}.yml")
unless File.exist?(file)
  raise LoadError.new "there's no #{file}"
end

config = YAML::load_file file
config['site'].each_pair do |key, value|
  set key.to_sym, value
end

%w(database image_domain sitename handshake).each do |key|
  raise ArgumentError.new "#{key} is not set, please set it" unless settings.respond_to? key.to_sym
end

require File.expand_path('../app/imglog', __FILE__)

run ImgLog::Site
