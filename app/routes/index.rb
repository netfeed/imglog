module ImgLog
  class Site
    get '/' do
      @days = StaticDay.limit(5).order(:date.desc)
      
      mustache :index
    end
  end
end