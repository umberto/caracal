require 'ostruct'
require 'caracal/core/models/base_model'
require 'caracal/core/models/has_color'
require 'caracal/core/models/has_background'
require 'caracal/core/models/has_margins'
require 'caracal/core/models/has_borders'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # paragraph style data.
      class StyleModel < BaseModel
        use_prefix :style

        include HasBackground
        include HasColor
        include HasBorders
        extend HasMargins

        has_margins

        has_string_attribute :id
        has_string_attribute :name
        has_string_attribute :font
        has_string_attribute :highlight_color
        has_string_attribute :base, default: 'Normal'
        has_string_attribute :next, default: 'Normal'

        has_integer_attribute :size, default: 20
        has_integer_attribute :line, default: 360 # 0.25in in twips
        has_integer_attribute :indent_left  # twips
        has_integer_attribute :indent_right # twips
        has_integer_attribute :indent_first # twips

        # %w(top bottom left right horizontal vertical).each do |dir|
        #   has_integer_attribute "border_#{dir}_size"
        #   has_integer_attribute "border_#{dir}_spacing"
        #
        #   has_string_attribute "border_#{dir}_color"
        #   has_string_attribute "border_#{dir}_line"
        #
        #   has_model_attribute "border_#{dir}_theme_color"
        # end

        has_boolean_attribute :default, default: false
        has_boolean_attribute :bold
        has_boolean_attribute :italic
        has_boolean_attribute :underline
        has_boolean_attribute :caps
        has_boolean_attribute :small_caps
        has_boolean_attribute :strike
        has_boolean_attribute :keep_next
        has_boolean_attribute :keep_lines
        has_boolean_attribute :widow_control
        has_boolean_attribute :word_wrap
        has_boolean_attribute :locked
        has_boolean_attribute :before_autospacing, default: true
        has_boolean_attribute :after_autospacing, default: true

        has_symbol_attribute :line_rule, default: :exact
        has_symbol_attribute :type, default: :paragraph, downcase: true
        has_symbol_attribute :align, default: :left
        has_symbol_attribute :vertical_align, default: :baseline

        TYPES             = %i(character paragraph table table_row table_cell)
        VERTICAL_ALIGNS   = %i(subscript superscript baseline center bottom auto)
        HORIZONTAL_ALIGNS = %i(left center right both)
        LINE_RULES        = %i(exact auto atLeast)

        # initialization
        def initialize(options={}, &block)
          super options, &block

          if self.style_id == self.class::DEFAULT_STYLE_BASE
            @style_default = true
            @style_base    = nil
          else
            @style_default = false
            @style_base    ||= DEFAULT_STYLE_BASE
          end

          @style_type           ||= DEFAULT_STYLE_TYPE
          @style_next           = DEFAULT_STYLE_NEXT
          @style_size           ||= DEFAULT_STYLE_SIZE
          @style_bold           = DEFAULT_STYLE_BOLD      if @style_bold.nil?
          @style_italic         = DEFAULT_STYLE_ITALIC    if @style_italic.nil?
          @style_underline      = DEFAULT_STYLE_UNDERLINE if @style_underline.nil?
          @style_caps           = DEFAULT_STYLE_CAPS      if @style_caps.nil?
          @style_small_caps     = DEFAULT_STYLE_CAPS      if @style_small_caps.nil?
          @style_strike         = DEFAULT_STYLE_CAPS      if @style_strike.nil?
          @style_align          ||= DEFAULT_STYLE_ALIGN
          @style_vertical_align ||= DEFAULT_STYLE_VERTICAL_ALIGN
          @style_top            ||= DEFAULT_STYLE_TOP
          @style_bottom         ||= DEFAULT_STYLE_BOTTOM
          @style_left           ||= DEFAULT_STYLE_LEFT
          @style_right          ||= DEFAULT_STYLE_RIGHT
          @style_line           ||= DEFAULT_STYLE_LINE
          @style_line_rule      ||= DEFAULT_STYLE_LINE_RULE
          @style_word_wrap      ||= DEFAULT_STYLE_WORD_WRAP

          # raise options.inspect if self.style_type.to_s == 'table'
        end


        #========== GETTERS ===============================

        def style_outline_lvl
          style_id.match(/Heading(\d)\Z/) {|match| match[1].to_i }
        end

        def run_attributes
          attrs = {
            font:            self.style_font,
            color:           self.style_color,
            theme_color:     self.style_theme_color,
            size:            self.style_size,
            bold:            self.style_bold,
            italic:          self.style_italic,
            underline:       self.style_underline,
            bgcolor:         self.style_bgcolor,
            theme_bgcolor:   self.style_theme_bgcolor,
            bgstyle:         self.style_bgstyle,
            vertical_align:  self.style_vertical_align,
            # highlight_color: self.style_highlight_color
          }.compact
          OpenStruct.new attrs
        end


        #========== STATE =================================

        def matches?(str)
          style_id.downcase == str.to_s.downcase
        end


        #========== VALIDATION ============================

        def valid?
          validate_presence :id and
              validate_presence :name and
              validate_presence :type and
              validate_inclusion :type, within: TYPES and
              validate_inclusion :vertical_align, within: VERTICAL_ALIGNS and
              validate_inclusion :align, within: HORIZONTAL_ALIGNS and
              validate_inclusion :line_rule, within: LINE_RULES and
              self.valid_bgstyle?
        end

        def to_h
          option_keys.inject({}) do |h, k|
            v = self.send "#{self.class.attr_prefix}_#{k}"
            h[k] = v unless v.nil?
            h
          end
        end

        private

        def option_keys
          [:type, :base, :bold, :italic, :underline, :caps, :size, :line, :line_rule, :id, :name, :font, :align, :widow_control, :word_wrap, :keep_lines, :keep_next, :locked] +
              HasBackground::ATTRS +
              HasColor::ATTRS +
              HasMargins::ATTRS +
              HasBorders::ATTRS +
              %w(left right first).map{|b| :"indent_#{b}" }
        end

      end

    end
  end
end
