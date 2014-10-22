module SuperbTextConstructor
  module Concerns
    module Models
      module Block
        extend ActiveSupport::Concern

        included do
          serialize :data, Hash

          SuperbTextConstructor.uploaders.each do |field, uploader|
            mount_uploader field.to_sym, uploader.constantize, serialize_to: :data
          end

          belongs_to :blockable, polymorphic: true

          default_scope -> { order(position: :asc) }

          before_validation :set_position, unless: :position
          after_destroy :recalculate_positions

          validates_presence_of :blockable
          validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
          validates :template, presence: true, inclusion: { in: SuperbTextConstructor.templates }
          SuperbTextConstructor.fields.each do |field|
            validates field.to_sym, presence: true, if: "#{field}_required?".to_sym
          end
        end

        # Define methods for reading/writing serialized data
        SuperbTextConstructor.fields.each do |field|
          define_method "#{field}_required?" do
            fields[field].try(:fetch, 'required', nil) == true
          end

          next if method_defined?(field)

          define_method field do
            data.try(:fetch, field, nil)
          end

          define_method "#{field}=" do |value|
            self.data ||= {}
            self.data[field] = value
          end

          define_method "#{field}_was" do
            data_was.try(:fetch, field)
          end

          define_method "#{field}_changed?" do
            instance_variable_get("@#{field}_changed") || send(field) != send("#{field}_was")
          end

          define_method "#{field}_will_change!" do
            instance_variable_set("@#{field}_changed", true)
          end
        end

        # @return [Hash] template options
        def template_options
          SuperbTextConstructor.blocks[template] || {}
        end

        # @return [Hash] available fields for this block
        def fields
          template_options['fields'] || {}
        end

        # @return [Boolean] whether block could be created without any actions by user
        def auto?
          fields.empty?
        end

        # Copies all the attributes from another block
        # @param original [Block] the orignal block
        # @return [Block] self with new attributes
        def copy_from(original)
          self.template = original.template
          self.position = original.position
          self.data = original.data
          self
        end

        private

          # Adds new block to the end of list (with max+1 position)
          def set_position
            self.position = blockable.reload.blocks.map(&:position).max.to_i + 1
          end

          # Recalculates positions for the blocks after destroyed block
          def recalculate_positions
            blocks = blockable.reload.blocks.where('position > ?', position)
            blocks.each_with_index do |block, index|
              block.update_column(:position, position + index)
            end
          end

      end
    end
  end
end