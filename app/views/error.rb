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