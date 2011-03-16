module Timestamps
  module InstanceMethods
    def before_create
      self.created_date ||= Date.today
      self.created_time ||= Time.now
      self.updated ||= Time.now
      super
    end
    
    def before_update
      self.updated ||= Time.now
      super
    end
  end
end