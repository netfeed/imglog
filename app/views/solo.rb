# -*- coding: utf-8 -*-
# Copyright (c) 2011 Victor Bergöö
# This program is made available under the terms of the MIT License.

module ImgLog
  class Site
    module Views
      class Solo < Layout
        attr_reader :image

        def title
          "#{super} | #{date} - #{image.id}"
        end

        def date
          image.created_date
        end

        def middle
          {
            :pretty_date => image.created_date.strftime("%d %B %Y"),
            :date_path => ['/image', image.created_date.strftime('%Y/%m/%d')].join('/')
          }
        end

        def thumbs
          md5 = image.md5
          thumbs = {}
          Image.filter(:created_date => image.created_date, :active => true).filter{(~{:md5 => md5})}.order{random{}}.each do |image|
            thumbs[image.md5] = image
            break if thumbs.size >= 5
          end
          thumbs.values
        end
        
        def previous 
          md5 = image.md5
          Image.filter(:id.identifier > image.id, :active => true).filter{(~{:md5 => md5})}.order(:id.asc).limit(1).first
        end
        
        def next
          md5 = image.md5
          Image.filter(:id.identifier < image.id, :active => true).filter{(~{:md5 => md5})}.order(:id.desc).limit(1).first
        end
        
        def has_thumbs
          not thumbs.empty?
        end
        
        def shadow
          true
        end
        
        def opengraph
          {
            :title => name,
            :url => [settings.site_domain, 'image', image.created_date.strftime('%Y/%m/%d'), image.id].join('/'),
            :image => image.thumbnail
          }
        end
      end
    end
  end
end