dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include? dir

require 'sinatra/base'
require 'sinatra/sequel'
require 'mustache/sinatra'
require 'sequel'
require 'json'

module ImgLog
  class Site < Sinatra::Base
    register Mustache::Sinatra
    
    configure do
      set :mustache, {
        :views => './app/views',
        :templates => './app/templates',
      }
      set :views, './app/views' # for sass and coffescript
    end
    
    get '/css/imglog.css' do
      sass :imglog
    end
    
    error do
      @error = "500: Internal server error"
      @image = Image.filter(:active => true).order(:id.desc).limit(1)
      mustache :error
    end unless Sinatra::Application.environment == :development
    
    not_found do
      @error = "404: Not found"
      @image = Image.filter(:active => true).order(:id.desc).limit(1)
      mustache :error
    end
  end
end

require 'models'

require 'routes/index'
require 'routes/image'

require 'views/layout'
require 'views/index'
require 'views/day'
require 'views/error'
require 'views/month'
require 'views/solo'
