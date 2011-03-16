module ImgLog
  class Site
    module Views
      class Index < Layout
        def images
          @days.map do |day|
            images = []
            Image.by_date(day.date).each do |image|
              images << image unless images.map(&:md5).include? image.md5
              break if images.size >= 10
            end
            
            {
              :date => day.date,
              :amount => day.count,
              :has_more => day.count > 10,
              :date_path => ['/image', day.date.strftime('%Y/%m/%d')].join('/'),
              :thumbs => [ { :row => images[0..4] }, { :row => images[5..9] } ]
            }
          end
        end
      end
    end
  end
end
