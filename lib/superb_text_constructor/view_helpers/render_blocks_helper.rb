module SuperbTextConstructor
  module ViewHelpers
    module RenderBlocksHelper

      # View helper for notifications rendering.
      # @param blocks [Array<Block>] list of blocks to be rendered
      # @param options [Hash] render options
      # @option options [Symbol, String] :namespace
      #   Be default: nil (the same as block's parent class name)
      # @return [ActiveSupport::SafeBuffer] rendered HTML code
      # @return [nil] if empty array was passed
      def render_blocks(blocks, options = {})
        return nil if blocks.empty?
        blocks.map { |block| render_block(block, options) }.join.html_safe
      end

      # View helper for block rendering
      # @param block [Block] single block to be rendered
      # @option options [Hash] #see render_blocks
      # @return [ActiveSupport::SafeBuffer] rendered HTML code
      def render_block(block, options = {})
        render partial: partial_name_for(block, options), object: block, as: :block
      end

      private

        # Looks for the appropriate partial
        # @param block [Block] single block to be rendered
        # @option options [Hash] #see render_blocks
        # @return [String] partial name
        def partial_name_for(block, options = {})
          if options[:namespace] && lookup_context.template_exists?("superb_text_constructor/blocks/#{options[:namespace]}/#{block.template}", nil, true)
            "superb_text_constructor/blocks/#{options[:namespace]}/#{block.template}"
          else
            "superb_text_constructor/blocks/#{SuperbTextConstructor.default_namespace.name}/#{block.template}"
          end
        end

    end
  end
end
