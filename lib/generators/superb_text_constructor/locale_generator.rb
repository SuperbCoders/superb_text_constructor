module SuperbTextConstructor
  module Generators
    # Generator that creates models from templates
    class LocaleGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_locale
        template 'locales/superb_text_constructor.en.yml', 'config/locales/superb_text_constructor.en.yml'
      end

    end
  end
end
