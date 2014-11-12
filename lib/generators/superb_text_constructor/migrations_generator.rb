require 'rails/generators/active_record'

module SuperbTextConstructor
  module Generators
    # Generator that creates migrations from templates
    class MigrationsGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :name, type: :string, default: 'create_blocks'

      def copy_migrations
        migration_template 'migrations/create_superb_text_constructor_blocks.rb', 'db/migrate/create_superb_text_constructor_blocks.rb'
      end

    end
  end
end
