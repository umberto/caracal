# frozen_string_literal: true

require 'caracal/core/models/text_model'

module Caracal
  module Core
    module Models
      # This class encapsulates the logic needed to store and manipulate link data.
      class LinkModel < TextModel
        use_prefix :link

        DEFAULT_LINK_COLOR = '1155cc'

        has_string_attribute :href

        has_boolean_attribute :underline, default: true
        has_boolean_attribute :internal

        # readers (create aliases for superclass methods to conform
        # to expected naming convention.)
        alias link_content text_content
        alias link_font text_font
        alias link_color text_color
        alias link_size text_size
        alias link_bold text_bold
        alias link_italic text_italic
        alias link_underline text_underline
        alias link_bgcolor text_bgcolor
        alias link_highlight_color text_highlight_color
        alias link_vertical_align text_vertical_align

        # initialization
        def initialize(options = {}, &block)
          @text_color     = DEFAULT_LINK_COLOR
          @text_underline = DEFAULT_LINK_UNDERLINE

          super options, &block
        end

        #========== STATE HELPERS =========================

        def external?
          !link_internal
        end

        #========== VALIDATION ============================

        def valid?
          %i[content href].all? { |a| validate_presence a }
        end

        private

        def option_keys
          (super + %i[internal href]).flatten
        end
      end
    end
  end
end
