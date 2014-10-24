module SuperbTextConstructor
  module Generators
    # Generator that installs all the parts of gem
    class InstallGenerator < ::Rails::Generators::Base

      def generate_migrations
        generate 'superb_text_constructor:migrations'
      end

      def generate_models
        generate 'superb_text_constructor:models'
      end

      def generate_initializer
        generate 'superb_text_constructor:initializer'
      end

      def generate_config
        generate 'superb_text_constructor:config'
      end

    end
  end
end
