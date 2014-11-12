module SuperbTextConstructor
  # Represents the blocks namespace. Stores information such as the name and available for this namespace blocks.
  class Namespace

    attr_reader :name, :blocks

    # @param name [Symbol] name of the namespace
    # @yield DSL description of the namespace
    def initialize(name, &block)
      @name = name
      @blocks = []
      instance_eval(&block) if block_given?
    end

    # Adds a block tho the namespace
    # @param block_name [Symbol] name of the block that belongs to this namespace
    # @raise [NameError] if block with specified name was not defined yearlier
    # @return [Class] class of the used block
    def use(block_name)
      block_class = "SuperbTextConstructor::#{block_name.to_s.camelize}".constantize
      @blocks << block_class
      block_class
    end

    # Adds another namespace inside this namespace and yields into it
    # @param name [Symbol] name of the inner namespace
    # @yield DSL description of the namespace
    # @return [SuperbTextConstructor::Namespace] added namespace
    def group(name, &block)
      namespace = Namespace.new(name, &block)
      @blocks << namespace
      namespace
    end

    # Defines new block and uses it
    # @see SuperbTextConstructor.block
    # @see #use
    def block(name, &block)
      klass = SuperbTextConstructor.block(name, &block)
      @blocks << klass
      klass
    end

  end
end
