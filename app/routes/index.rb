# -*- coding: utf-8 -*-
# Copyright (c) 2011 Victor Bergöö
# This program is made available under the terms of the MIT License.

module ImgLog
  class Site
    get '/' do
      @days = StaticDay.limit(5).order(:date.desc)
      
      mustache :index
    end
  end
end