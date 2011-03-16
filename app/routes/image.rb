module ImgLog
  class Site
    get %r{/image/(\d{4})/(\d{2})/(\d{2})/(\d+)/?} do |year, month, day, id|
      date = Date.parse [year, month, day].join('-')
      @image = Image.first(:id => id, :created_date => date, :active => true)
      
      unless @image
        not_found
      end
      
      mustache :solo
    end

    get %r{/image/(\d{4})/(\d{2})/(\d{2})/?} do |year, month, day|
      @date = Date.parse [year, month, day].join('-')
      @images = Image.by_date @date

      mustache :day
    end
  
    get %r{/image/(\d{4})/(\d{2})/?} do |year, month|
      bottom = Date.parse [year, month, 01].join('-')
      top = (bottom >> 1)
      offset = params["page"] && params["page"].to_i > 0 ? ((params["page"].to_i - 1) * 5) : 0

      @days = StaticDay.filter(:date => bottom...top).limit(5, offset).all
      @previous = params["page"].nil? ? 0 : (params["page"].to_i - 1)

      outer = @days.last.date
      
      @next = params["page"].nil? ? 2 : (params["page"].to_i + 1)
      @next = nil if @days.last.date.day == (Date.new(Time.now.year, 12, 31).to_date << (12 - month.to_i)).day
      @next = nil if StaticDay.filter{(date > outer) & (date < top)}.all.size == 0

      mustache :month
    end

    get %r{/image/(\d{4})/?} do
      redirect '/'
    end
    
    get '/image/?' do
      redirect '/'
    end
    
    post '/image/add/?' do 
      if params[:json].nil?
        status 400
        return { :error => 'missing parameter' }.to_json
      end

      begin
        json = JSON.parse(params[:json])
      rescue JSON::ParserError => e
        status 400
        return { :error => 'json parse exception' }.to_json
      end

      if json["handshake"] != Sinatra::Application.settings.handshake
        status 400
        return { :error => "handshake failed" }.to_json
      end

      network = Network.filter(:name => json["server"]).first
      return { :error => "No such network: #{json['server']}" }.to_json if network.nil?
      
      channel = Channel.filter(:name => json["channel"], :network_id => network.id).first
      if channel.nil?
        channel = Channel.create(:name => json["channel"], :network_id => network.id)
      end
      
      hsh = {
        :md5 => json["md5"],
        :size => json["size"],
        :width => json["width"],
        :height => json["height"],
        :original_url => json["url"],
        :pretty_url => nil,
        :user => json["user"],
        :channel_id => channel.id
      }
      
      unless json["created_date"].nil?
        hsh["created_date"] = json["created_date"]
      end
      
      image = Image.create(hsh)

      {
        :thumb => image.thumbnail(false),
        :image => image.image(false),
        :medium => image.medium(false),
      }.to_json
    end
  end
end