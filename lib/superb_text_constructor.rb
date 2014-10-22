require 'superb_text_constructor/engine'
require 'superb_text_constructor/view_helpers/render_blocks_helper'
require 'superb_text_constructor/view_helpers/sanitize_block_helper'
require 'superb_text_constructor/route_mappings'

require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave-serializable'

module SuperbTextConstructor
  DEFAULTS = {
    configs_path: nil,
    default_namespace: 'default',
    additional_permitted_attributes: nil
  }

  mattr_accessor :configuration
  self.configuration = OpenStruct.new

  DEFAULTS.each do |key, value|
    self.configuration.send("#{key}=", value)
  end

  def self.configure(&block)
    yield(self.configuration)
    require 'superb_text_constructor/concerns/models/block'
    require 'superb_text_constructor/concerns/models/blockable'
    require 'superb_text_constructor/concerns/controllers/blocks_controller'
  end

  # @return [Hash] all available blocks in all namespaces
  def self.blocks
    config['blocks'] || {}
  end

  # @return [Array<Hash>] list of available namespaces
  def self.namespaces
    config['namespaces'] || {}
  end

  # @return [Array<String] list of available fields for all blocks
  def self.fields
    blocks.map { |block, options| (options || {}).fetch('fields', {}).keys }.flatten.uniq
  end

  # @return [Array<String] list of available fields for all blocks
  def self.uploaders
    result = {}
    blocks.each do |_, options|
      (options || {}).fetch('fields', {}).each do |field, options|
        result[field] = options['uploader'] if options['uploader'].present?
      end
    end
    result
  end

  # @return [Array<String] list of available block names
  def self.templates
    blocks.keys
  end

  private

    def self.config
      @config ||= read_config
    end

    # Reads all config files and merges them to one Hash
    # @return [Hash] merged configs
    def self.read_config
      result = {}
      [self.configuration.configs_path].flatten.each do |file_path|
        result.deep_merge!(YAML.load_file(file_path))
      end
      result
    end

end
