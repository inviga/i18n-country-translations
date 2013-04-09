require 'rails'

module I18nCountryTranslations
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'i18n-country-translations' do |app|
      I18nCountryTranslations::Railtie.instance_eval do
        pattern = pattern_from app.config.i18n.available_locales

        add("rails/locale/#{pattern}.yml")
      end
    end

    protected

    def self.add(pattern)
      files = Dir[File.join(File.dirname(__FILE__), '../..', pattern)]
      I18n.load_path.concat(files)
    end

    def self.pattern_from(args)
      args ||= []
      array = args.map(&:to_s).inject([]) do |memo, obj|
        # Add the requested locale
        memo << obj
        # If the requested locale specifies a sub-language, make sure we add the default-language too.
        if /^(\w{2,3})-\w+/.match(obj)
          memo << $1
        end
        memo
      end
      array.blank? ? '*' : "{#{array.uniq.join ','}}"
    end
  end
end
