module SuperbTextConstructor
  module Generators
    # Generator that installs all the parts of gem
    class InstallGenerator < ::Rails::Generators::Base

      def generate_migrations
        generate 'superb_text_constructor:migrations'
      end

      def generate_initializer
        generate 'superb_text_constructor:initializer'
      end

    end
  end
end
