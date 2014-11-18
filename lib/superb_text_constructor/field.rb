module SuperbTextConstructor
  # Describes a field of the block
  class Field
    # @return [Hash] default values of field options
    DEFAULTS = {
      type: String,
      required: false
    }

    attr_reader :name

    def initialize(name, options = {})
      @name = name
      type(options[:type] || DEFAULTS[:type])
      partial(options[:partial]) if options[:partial].present?
      required(options[:required].nil? ? DEFAULTS[:required] : options[:required])
    end

    def type(value = nil)
      if value.nil?
        @type
      else
        raise 'Field type should be a Class' unless value.is_a?(Class)
        @type = value
        self
      end
    end

    def required(value = true)
      @required = value
      self
    end

    def required?
      @required
    end

    def uploader?
      type.is_a?(Class) && type.name.end_with?('Uploader')
    end

    def partial(value = nil)
      if value.nil?
        @partial ||= type.name.to_s.underscore
      else
        @partial = value
        self
      end
    end

    def nested?
      partial == 'nested'
    end
  end
end
