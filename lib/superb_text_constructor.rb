# Rails stuff
require 'superb_text_constructor/engine'
require 'superb_text_constructor/view_helpers/render_blocks_helper'
require 'superb_text_constructor/view_helpers/editor_helper'
require 'superb_text_constructor/view_helpers/sanitize_block_helper'
require 'superb_text_constructor/route_mappings'

# Carrierwave stuff
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave-serializable'

# jQuery fileupload stuff
require 'jquery-fileupload-rails'

# Internal classes
require 'superb_text_constructor/namespace'
require 'superb_text_constructor/field'

# Concerns
require 'superb_text_constructor/concerns/models/block'
require 'superb_text_constructor/concerns/models/blockable'
require 'superb_text_constructor/concerns/controllers/blocks_controller'

module SuperbTextConstructor

  def self.configure(&block)
    instance_eval(&block)
  end

  def self.namespace(name, &block)
    namespace = SuperbTextConstructor::Namespace.new(name, &block)
    namespaces << namespace
    namespace
  end

  def self.namespaces
    @namespaces ||= []
  end

  def self.default_namespace
    namespaces.first
  end

  # @param name [Symbol] name of the namespace
  # @return [Array<Block, Namespace>] list of blocks and nested namespaces
  # @raise [Error] if namespace with the specified name does not exist
  def self.blocks_for(name)
    ns = namespaces.select { |ns| ns.name.to_s == name.to_s }.first
    raise 'Unknown namespace' unless ns
    ns.blocks
  end

  # @param name [Symbol] name of the block
  # @yield DSL definiton of the block
  # @return [Class] defined block
  def self.block(name, &block)
    klass_name = name.to_s.camelize
    klass = SuperbTextConstructor.const_set(klass_name, Class.new(SuperbTextConstructor::Block))
    klass.class_eval(&block) if block_given?
    klass
  end

end
