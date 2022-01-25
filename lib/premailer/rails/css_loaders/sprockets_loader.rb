class Premailer
  module Rails
    module CSSLoaders
      module SprocketsLoader
        extend self

        def load(url)
          return unless sprockets_present?

          file = file_name(url)
          ::Rails.application.assets_manifest.find_sources(file).first
        rescue Errno::ENOENT, TypeError => _e
        end

        def file_name(url)
          prefix = [
            ::Rails.configuration.relative_url_root,
            ::Rails.configuration.assets.prefix,
            '/'
          ].join
          URI(url).path
                  .sub(/\A#{prefix}/, '')
                  .sub(/-(\h{32}|\h{64})\.css\z/, '.css')
        end

        def sprockets_present?
          defined?(::Rails) &&
            ::Rails.respond_to?(:application) &&
            ::Rails.application &&
            ::Rails.application.respond_to?(:assets_manifest) &&
            ::Rails.application.assets_manifest
        end
      end
    end
  end
end
