module ImgLog
  class Site
    module Views
      class Month < Layout
        def title
          date = @days.first.date.strftime("%B %Y")
          "#{super} | #{date}"
        end
        
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
        
        def next_month
          d = @days.sort{ |a, b| a.date <=> a.date }.last.date
          dataset = StaticDay.filter{date > d}.order(:date.asc).limit(31)
          next_month = comming_month dataset
          
          return nil unless next_month
          date = next_month.strftime('%Y/%m/')
          {
            :date_path => "/image/#{date}",
            :pretty_date => next_month.strftime("%B %Y")
          }
        end
        
        def previous_month
          d = @days.sort{ |a, b| a.date <=> a.date }.first.date
          dataset = StaticDay.filter{date < d}.order(:date.desc).limit(31)
          previous_month = comming_month dataset
          
          return nil unless previous_month
          date = previous_month.strftime('%Y/%m/')
          {
            :date_path => "/image/#{date}",
            :pretty_date => previous_month.strftime("%B %Y")
          }
        end
        
        def previous
          return false if @previous.nil? || @previous < 1 
          date = @days.first.date.strftime('%Y/%m/')
          { :url => "/image/#{date}?page=#{@previous}" }
        end
        
        def next 
          return false if @next.nil? 
          date = @days.first.date.strftime('%Y/%m/')
          { :url => "/image/#{date}?page=#{@next}" }
        end
        
        private
        
        def comming_month dataset
          dataset.each do |day|
            return day.date if day.date.month  != @days.first.date.month
          end
          
          nil
        end
      end
    end
  end
end