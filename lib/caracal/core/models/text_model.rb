require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class TextModel < BaseModel
        use_prefix :text

        has_string_attribute :bgcolor
        has_string_attribute :color
        has_string_attribute :content
        has_string_attribute :font
        has_string_attribute :highlight_color
        has_string_attribute :style

        has_symbol_attribute :vertical_align
        has_symbol_attribute :whitespace

        has_boolean_attribute :bold
        has_boolean_attribute :italic
        has_boolean_attribute :underline
        has_boolean_attribute :end_tab
        has_boolean_attribute :rtl

        has_integer_attribute :size

        #========== GETTERS ===============================

        def run_attributes
          {
            style:            text_style,
            font:             text_font,
            color:            text_color,
            size:             text_size,
            bold:             text_bold,
            italic:           text_italic,
            underline:        text_underline,
            bgcolor:          text_bgcolor,
            highlight_color:  text_highlight_color,
            vertical_align:   text_vertical_align,
            end_tab:          text_end_tab
          }
        end

        #========== VALIDATION ============================

        def valid?
          a = [:content]
          a.map { |m| send("text_#{ m }") }.compact.size == a.size
        end


        private

        def option_keys
          [:content, :style, :font, :color, :size, :bold, :italic, :underline, :bgcolor, :highlight_color, :vertical_align, :end_tab]
        end

        # def method_missing(method, *args, &block)
        #   # I'm on the fence with respect to this implementation. We're ignoring
        #   # :method_missing errors to allow syntax flexibility for paragraph-type
        #   # models.  The issue is the syntax format of those models--the way we pass
        #   # the content value as a special argument--coupled with the model's
        #   # ability to accept nested instructions.
        #   #
        #   # By ignoring method missing errors here, we can pass the entire paragraph
        #   # block in the initial, built-in call to :text.
        # end
      end

    end
  end
end
