require 'caracal/core/models/base_model'
require 'caracal/core/models/has_color'
require 'caracal/core/models/has_background'
require 'ostruct'

module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class TextModel < BaseModel
        use_prefix :text

        include HasColor
        include HasBackground

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
          attrs = {
            style:            self.text_style,
            font:             self.text_font,
            color:            self.text_color,
            theme_color:      self.text_theme_color,
            size:             self.text_size,
            bold:             self.text_bold,
            italic:           self.text_italic,
            underline:        self.text_underline,
            bgcolor:          self.text_bgcolor,
            theme_bgcolor:    self.text_theme_bgcolor,
            highlight_color:  self.text_highlight_color,
            vertical_align:   self.text_vertical_align,
            end_tab:          self.text_end_tab
          }.compact
          OpenStruct.new attrs
        end

        #========== VALIDATION ============================

        def valid?
          validate_presence :content, allow_empty: true
        end

        private

        def option_keys
          [:content, :style, :font, :size, :bold, :italic, :underline, :highlight_color, :vertical_align, :end_tab] + HasBackground::ATTRS + HasColor::ATTRS
        end

      end

    end
  end
end
