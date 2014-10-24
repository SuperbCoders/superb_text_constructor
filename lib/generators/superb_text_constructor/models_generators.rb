module SuperbTextConstructor
  module Generators
    # Generator that creates models from templates
    class ModelsGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_models
        template 'models/block.rb', 'app/models/block.rb'
      end

    end
  end
end
