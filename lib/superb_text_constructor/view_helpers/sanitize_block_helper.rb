module SuperbTextConstructor
  module ViewHelpers
    module SanitizeBlockHelper

      # Removes forbidden tags from text
      # @param text [String] original text
      # @return [ActiveSupport::SafeBuffer] HTML safe text with permitted only tags
      def sanitize_block(text)
        sanitize(text.to_s, tags: %w(a b i img span br), attributes: %w(id class style src href target))
      end


      # Adds HTML markup to plain text with paragraphs separated by new lines and removes forbidden tags.
      # @param text [String] original text
      # @return [ActiveSupport::SafeBuffer] HTML safe text splitted by <p> tags
      def sanitize_and_paragraph_block(text)
        sanitize_and_split_block(text, 'p')
      end

      # Adds HTML markup to plain text with paragraphs separated by new lines and removes forbidden tags.
      # @param text [String] original text
      # @param tag [Symbol] wrapper tag name. E.g. :p, :li
      # @return [ActiveSupport::SafeBuffer] HTML safe text splitted by selected tags
      def sanitize_and_split_block(text, tag)
        paragraphs = sanitize_block(text).split("\r\n\r\n").map(&:strip).select(&:present?)
        paragraphs.map { |p| content_tag tag do p.html_safe end }.join("\r\n").html_safe
      end

    end
  end
end
