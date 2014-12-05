module SuperbTextConstructor
  module Concerns
    module Models
      module Block
        extend ActiveSupport::Concern

        included do
          serialize :data, Hash

          belongs_to :blockable, polymorphic: true

          default_scope -> { order(position: :asc) }

          before_validation :set_position, unless: :position
          after_destroy :recalculate_positions

          validates_presence_of :blockable
          validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
        end

        # @return [Boolean] whether block could be created without any actions by user
        def auto?
          fields.empty?
        end

        # Copies all the attributes from another block
        # @param original [Block] the orignal block
        # @return [Block] self with new attributes
        def copy_from(original)
          self.type = original.type
          self.position = original.position
          self.data = original.data
          self
        end

        def fields
          self.class.fields
        end

        def template
          self.class.template
        end

        module ClassMethods
          def field(name, options = {}, &block)
            # Initialize new Field object
            field = SuperbTextConstructor::Field.new(name, options)
            field.instance_eval(&block) if block_given?

            # Mount uploader if needed
            if field.uploader?
              mount_uploader field.name, field.type, serialize_to: :data
            # Or define methods for reading and writing to the field
            else
              define_method field.name do
                data.try(:fetch, field.name, nil)
              end

              define_method "#{field.name}=" do |value|
                self.data ||= {}
                case field.type.name
                when 'TrueClass', 'FalseClass' then self.data[field.name] = value.present? && value.to_s != '0'
                else self.data[field.name] = value
                end
              end

              define_method "#{field.name}_was" do
                data_was.try(:fetch, field.name)
              end

              define_method "#{field.name}_changed?" do
                instance_variable_get("@#{field.name}_changed") || send(field.name) != send("#{field.name}_was")
              end

              define_method "#{field.name}_will_change!" do
                instance_variable_set("@#{field.name}_changed", true)
              end
            end

            # Describe validations
            # @todo Temporary disabled presence validation
            # if field.required?
            #   validates field.name, presence: true
            # end

            fields << field
          end

          def nested_blocks(name, options = {}, &block)
            nested_name = name.to_sym
            full_name = "#{template}_#{nested_name.to_s.underscore.singularize}"
            klass = SuperbTextConstructor.block(full_name, &block)
            field = SuperbTextConstructor::Field.new(nested_name, type: klass, partial: 'nested')
            has_many nested_name, class_name: klass.name, as: :blockable, dependent: :destroy, inverse_of: :blockable
            accepts_nested_attributes_for name, allow_destroy: true
            fields << field
          end

          def fields
            @fields ||= []
          end

          def name_without_namespace
            name.gsub('SuperbTextConstructor::', '')
          end

          def template
            name_without_namespace.underscore
          end
        end

        def nested?
          blockable.class.superclass == SuperbTextConstructor::Block
        end

        private

          # Adds new block to the end of list (with max+1 position)
          def set_position
            if nested?
              self.position = 1
            else
              self.position = blockable.reload.blocks.map(&:position).max.to_i + 1
            end
          end

          # Recalculates positions for the blocks after destroyed block
          def recalculate_positions
            return true if nested?
            blocks = blockable.reload.blocks.where('position > ?', position)
            blocks.each_with_index do |block, index|
              block.update_column(:position, position + index)
            end
          end

      end
    end
  end
end