class Premailer
  module Rails
    module CSSLoaders
      module PropshaftLoader
        extend self

        def load(url)
          return unless propshaft_present?

          file = file_name(url)
          ::Rails.application.assets.load_path.find(file)
        rescue Errno::ENOENT, TypeError => _e
        end

        def file_name(url)
          prefix = [
            ::Rails.configuration.relative_url_root,
            ::Rails.configuration.assets.prefix,
            '/'
          ].join
          digest = url[/-([0-9a-f]{7,128})\.(?!digested)[^.]+\z/, 1]

          path = URI(url).path
                         .sub(prefix, '')
          digest ? path.sub("-#{digest}", '') : path
        end

        def propshaft_present?
          defined?(::Rails) &&
            ::Rails.respond_to?(:application) &&
            ::Rails.application &&
            ::Rails.application.respond_to?(:assets) &&
            ::Rails.application.assets.is_a?(Propshaft::Assembly)
        end
      end
    end
  end
end
