# frozen_string_literal: true

require 'caracal/core/models/base_model'
require 'caracal/core/models/has_run_attributes'
require 'ostruct'

module Caracal
  module Core
    module Models
      # This class encapsulates the logic needed to store and manipulate
      # text data.
      #
      class TextModel < BaseModel
        use_prefix :text

        include HasRunAttributes

        has_string_attribute :content
        has_string_attribute :style

        has_boolean_attribute :end_tab

        #========== GETTERS ===============================

        def run_attributes
          attrs = {
            style: text_style,
            font: text_font,
            color: text_color,
            theme_color: text_theme_color,
            size: text_size,
            bold: text_bold,
            italic: text_italic,
            underline: text_underline,
            caps: text_caps,
            strike: text_strike,
            small_caps: text_small_caps,
            bgcolor: text_bgcolor,
            theme_bgcolor: text_theme_bgcolor,
            highlight_color: text_highlight_color,
            vertical_align: text_vertical_align,
            end_tab: text_end_tab
          }.compact
          OpenStruct.new attrs
        end

        #========== VALIDATION ============================

        def valid?
          validate_presence :content, allow_empty: true and valid_run_attributes?
        end

        def self.option_keys
          %i[content style end_tab] + HasRunAttributes::ATTRS
        end

        private

        def option_keys
          self.class.option_keys
        end
      end
    end
  end
end
