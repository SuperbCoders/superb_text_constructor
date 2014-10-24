module SuperbTextConstructor
  module Generators
    # Generator that creates models from templates
    class InitializerGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'initializers/superb_text_constructor.rb', 'config/initializers/superb_text_constructor.rb'
      end

    end
  end
end
