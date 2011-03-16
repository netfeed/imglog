module ImgLog
  class Image < Sequel::Model
    plugin :validation_helpers
    plugin Timestamps
    
    many_to_one :channel

    class << self
      def by_date date, order = :desc
        filter(:created_date => date, :active => true).order(:created_time.send(order)).all
      end
    end

    def validate
      validates_presence [:md5, :size, :width, :height]
      validates_numeric [:size, :width, :height]
      validates_exact_length 32, :md5
      super
    end
    
    def thumbnail domain=true
      image_path "#{id}t", domain
    end
    
    def image domain=true
      image_path id, domain
    end

    def medium domain=true
      return image_path("#{id}m", domain) if width > 700
      image domain
    end

    def url
      ['', 'image', created_date.strftime('%Y/%m/%d'), id].join('/')
    end
    
    def after_save
      super

      hash = Hash.new { |hash, key| hash[key] = [] }
      Image.by_date(created_date).each do |row|
        next if hash[:amount].include? row.md5
        
        hash[:size] << row.size
        hash[:width] << row.width
        hash[:height] << row.height
        hash[:amount] << row.md5
      end
      
      static = StaticDay.filter(:date => created_date).first
      static = StaticDay.create(:date => created_date) if static.nil?
      static.update(
        :avg_width => mean(hash[:width]),
        :avg_height => mean(hash[:height]),
        :avg_size => mean(hash[:size]),
        :count => hash[:amount].size
      )
    end
    
    private 
    
    def image_path identifier, domain=true
      filename = "#{identifier}#{File.extname(original_url).downcase}"
      d = domain ? settings.image_domain : ''
      path = [d, channel.network.id, channel.id, created_date.strftime("%Y/%m/%d"), filename]
      path.join('/')
    end
    
    def sum arr
      arr.inject(0) { |sum, add| sum + add.to_i}
    end

    def mean arr
      sum(arr) / arr.size.to_f
    end
  end
end