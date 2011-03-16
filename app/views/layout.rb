module ImgLog
  class Site
    module Views
      class Layout < Mustache
        def name
          settings.sitename
        end

        def tagline
          settings.tagline
        end
        
        def title
          sub = " - #{tagline}" unless tagline.nil?
          "#{name}#{sub}"
        end
        
        def ga
          return if settings.google_analytics.nil? || settings.google_analytics.empty?
          {
            :code => settings.google_analytics
          }
        end
        
        def shadow
          nil
        end
      end
    end
  end
end
