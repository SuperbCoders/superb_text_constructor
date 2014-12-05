module SuperbTextConstructor
  module ViewHelpers
    module EditorHelper

      # Renders form for specified block.
      # It uses custom form if it exists in `forms` directory.
      # Otherwise it renders default form
      # @param block [Block] block which form should be rendered
      # @return [ActiveSupport::SafeBuffer] rendered HTML code
      def render_form(block, options = {})
        if lookup_context.template_exists?("superb_text_constructor/blocks/forms/#{block.template}", nil, true)
          render partial: "superb_text_constructor/blocks/forms/#{block.template}", object: block, as: :block
        else
          render partial: "superb_text_constructor/blocks/form", object: block, as: :block
        end
      end

    end
  end
end
