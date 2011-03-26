# -*- coding: utf-8 -*-
# Copyright (c) 2011 Victor Bergöö
# This program is made available under the terms of the MIT License.

module ImgLog
  class Site
    module Views
      class Day < Layout
        attr_reader :date
        
        def title
          "#{super} | #{date}"
        end
        
        def images
          ret = []
          temp = @images.inject({}) { |hash, obj| hash[obj.md5] = obj; hash }
          images = temp.values.sort{ |a, b| a.created_time <=> b.created_time }.reverse
          while images.size > 0
            ret << { :row => images.slice!(0..4) }
          end
          ret
        end
        
        def amount
          @images.size
        end

        def middle
          {
            :pretty_date => @images.first.created_date.strftime("%B %Y"),
            :date_path => ['/image', @images.first.created_date.strftime('%Y/%m')].join('/')
          }
        end
        
        def previous
          image = @images.first
          previous = Image.filter{(created_date < image.created_date)}.filter(:active => true).order(:created_date.desc).limit(1).first
          return nil unless previous

          { 
            :created_date => previous.created_date,
            :date_path => ['/image', previous.created_date.strftime('%Y/%m/%d')].join('/')
          }
        end
        
        def next
          image = @images.first
          next_image = Image.filter{(created_date > image.created_date)}.filter(:active => true).order(:created_date.asc).limit(1).first
          return nil unless next_image

          { 
            :created_date => next_image.created_date,
            :date_path => ['/image', next_image.created_date.strftime('%Y/%m/%d')].join('/')
          }
        end
      end
    end
  end
end