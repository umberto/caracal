# frozen_string_literal: true

require 'caracal/core/models/has_background'
require 'caracal/core/models/has_color'
require 'caracal/core/models/has_borders'

module Caracal
  module Core
    module Models
      module HasRunAttributes
        OWN_ATTRS = %i[font size bold italic underline caps small_caps strike rtl highlight_color
                       vertical_align whitespace].freeze
        ATTRS = OWN_ATTRS +
                HasBackground::ATTRS +
                HasColor::ATTRS +
                HasBorders::ATTRS

        VERTICAL_ALIGNS   = %i[subscript superscript baseline].freeze

        def self.included(base)
          base.include HasBackground
          base.include HasColor
          base.include HasBorders

          base.has_string_attribute :font
          base.has_string_attribute :highlight_color

          base.has_symbol_attribute :vertical_align
          base.has_symbol_attribute :whitespace

          base.has_boolean_attribute :bold
          base.has_boolean_attribute :italic
          base.has_boolean_attribute :underline
          base.has_boolean_attribute :caps
          base.has_boolean_attribute :small_caps
          base.has_boolean_attribute :strike
          base.has_boolean_attribute :rtl

          base.has_integer_attribute :size
        end

        def run_attributes
          attrs = {
            font: send("#{self.class.attr_prefix}_font"),
            color: send("#{self.class.attr_prefix}_color"),
            highlight_color: send("#{self.class.attr_prefix}_highlight_color"),
            theme_color: send("#{self.class.attr_prefix}_theme_color"),
            size: send("#{self.class.attr_prefix}_size"),
            bold: send("#{self.class.attr_prefix}_bold"),
            italic: send("#{self.class.attr_prefix}_italic"),
            underline: send("#{self.class.attr_prefix}_underline"),
            caps: send("#{self.class.attr_prefix}_caps"),
            small_caps: send("#{self.class.attr_prefix}_small_caps"),
            strike: send("#{self.class.attr_prefix}_strike"),
            bgcolor: send("#{self.class.attr_prefix}_bgcolor"),
            theme_bgcolor: send("#{self.class.attr_prefix}_theme_bgcolor"),
            bgstyle: send("#{self.class.attr_prefix}_bgstyle"),
            vertical_align: send("#{self.class.attr_prefix}_vertical_align"),
            rtl: send("#{self.class.attr_prefix}_rtl")
          }.compact
          OpenStruct.new attrs
        end

        private

        def valid_run_attributes?
          valid_whitespace? and valid_vertical_align? and valid_caps?
        end

        def valid_caps?
          if send("#{self.class.attr_prefix}_caps") && send("#{self.class.attr_prefix}_small_caps")
            errors << 'May have either caps or small caps but not both'
            false
          else
            true
          end
        end

        def valid_whitespace?
          validate_inclusion :whitespace, within: %i[preserve replace collapse], allow_nil: true
        end

        def valid_vertical_align?
          validate_inclusion :vertical_align, within: VERTICAL_ALIGNS, allow_nil: true
        end

        def initialize_run_attributes
          # so far, no defaults to be set here.
        end
      end
    end
  end
end
