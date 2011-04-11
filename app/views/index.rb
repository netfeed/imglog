# -*- coding: utf-8 -*-
# Copyright (c) 2011 Victor Bergöö
# This program is made available under the terms of the MIT License.

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
        
        def opengraph
          date = @days.sort{ |a, b| a.date <=> a.date }.first.date
          image = Image.by_date(date).sort{ |a, b| a.created_time <=> b.created_time}.reverse.first
          {
            :title => name,
            :url => [settings.site_domain, 'image', image.created_date.strftime('%Y/%m')].join('/'),
            :image => image.thumbnail
          }
        end
      end
    end
  end
end
