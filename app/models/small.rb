# -*- coding: utf-8 -*-
# Copyright (c) 2011 Victor Bergöö
# This program is made available under the terms of the MIT License.

module ImgLog
  class Channel < Sequel::Model
    plugin :validation_helpers
    
    many_to_one :network
    
    def validate
      validates_presence [:name]
      super
    end
  end
  
  class Network < Sequel::Model
    plugin :validation_helpers
    
    one_to_many :channels
    
    def validate
      validates_numeric :port if active
      validates_presence [:address, :port]  if active
      validates_presence [:name, :slug]
      validates_unique :name
      super
    end
  end
  
  class StaticDay < Sequel::Model
  end
end