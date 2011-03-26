# -*- coding: utf-8 -*-
# Copyright (c) 2011 Victor Bergöö
# This program is made available under the terms of the MIT License.

module ImgLog
  class Site
    module Views
      class Error < Layout
        attr_reader :error, :image
        
        def title
          "#{name} - Error: #{error}"
        end
      end
    end
  end
end