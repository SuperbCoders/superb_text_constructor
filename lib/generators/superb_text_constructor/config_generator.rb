module SuperbTextConstructor
  module Generators
    # Generator that creates models from templates
    class ConfigGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_config
        template 'configs/superb_text_constructor.yml', 'config/superb_text_constructor.yml'
      end

    end
  end
end
