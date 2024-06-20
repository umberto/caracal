# frozen_string_literal: true

require 'ostruct'
require 'caracal/core/models/base_model'
require 'caracal/core/models/has_margins'
require 'caracal/core/models/has_run_attributes'

module Caracal
  module Core
    module Models
      # This class encapsulates the logic needed to store and manipulate
      # paragraph style data.
      class StyleModel < BaseModel
        use_prefix :style

        include HasRunAttributes
        extend HasMargins

        has_margins

        has_string_attribute :id
        has_string_attribute :name
        has_string_attribute :aliases
        has_string_attribute :base, default: 'Normal'
        has_string_attribute :next, default: 'Normal'

        has_integer_attribute :line, default: 360 # 0.25in in twips
        has_integer_attribute :indent_left  # twips
        has_integer_attribute :indent_right # twips
        has_integer_attribute :indent_first # twips

        has_boolean_attribute :default, default: false
        has_boolean_attribute :keep_next
        has_boolean_attribute :keep_lines
        has_boolean_attribute :widow_control
        has_boolean_attribute :word_wrap
        has_boolean_attribute :locked
        has_boolean_attribute :before_autospacing, default: false
        has_boolean_attribute :after_autospacing, default: false

        has_symbol_attribute :line_rule, default: :exact
        has_symbol_attribute :type, default: :paragraph
        has_symbol_attribute :align, default: :left

        TYPES             = %i[character paragraph table table_row table_cell].freeze
        HORIZONTAL_ALIGNS = %i[left center right both].freeze
        LINE_RULES        = %i[exact auto atLeast].freeze

        # initialization
        def initialize(options = {}, &block)
          super options, &block

          if style_id == self.class::DEFAULT_STYLE_BASE
            @style_default = true
            @style_base    = nil
          else
            @style_default = false
            @style_base    ||= DEFAULT_STYLE_BASE
          end

          @style_type ||= DEFAULT_STYLE_TYPE
          @style_next = DEFAULT_STYLE_NEXT
          @style_top       ||= DEFAULT_STYLE_TOP
          @style_bottom    ||= DEFAULT_STYLE_BOTTOM
          @style_left      ||= DEFAULT_STYLE_LEFT
          @style_right     ||= DEFAULT_STYLE_RIGHT
          @style_line      ||= DEFAULT_STYLE_LINE
          @style_line_rule ||= DEFAULT_STYLE_LINE_RULE
          @style_word_wrap ||= DEFAULT_STYLE_WORD_WRAP

          # raise options.inspect if self.style_type.to_s == 'table'
        end

        #========== GETTERS ===============================

        def style_outline_lvl
          style_id.match(/Heading(\d)\Z/) { |match| match[1].to_i }
        end

        def run_attributes
          attrs = {
            font: style_font,
            color: style_color,
            theme_color: style_theme_color,
            size: style_size,
            bold: style_bold,
            italic: style_italic,
            underline: style_underline,
            caps: style_caps,
            small_caps: style_small_caps,
            bgcolor: style_bgcolor,
            theme_bgcolor: style_theme_bgcolor,
            bgstyle: style_bgstyle,
            vertical_align: style_vertical_align
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
            valid_type? and
            validate_inclusion :align, within: HORIZONTAL_ALIGNS and
            validate_inclusion :line_rule, within: LINE_RULES and
            valid_bgstyle? and
            valid_run_attributes?
        end

        def valid_type?
          validate_inclusion :type, within: TYPES
        end

        def to_h
          option_keys.each_with_object({}) do |k, h|
            v = send "#{self.class.attr_prefix}_#{k}"
            h[k] = v unless v.nil?
          end
        end

        # attributes that cannot be set via table styles and have to be set for each cell separately.
        def table_cell_style_attributes
          (%i[line line_rule align word_wrap keep_lines keep_next font
              size] + HasMargins::ATTRS + HasRunAttributes::OWN_ATTRS).each_with_object({}) do |k, h|
            v = send "#{self.class.attr_prefix}_#{k}"
            h[k] = v unless v.nil?
          end
        end

        private

        def option_keys
          %i[aliases type base line line_rule id name align widow_control word_wrap keep_lines
             keep_next locked] +
            HasMargins::ATTRS +
            HasRunAttributes::ATTRS +
            %w[left right first].map { |b| :"indent_#{b}" }
        end
      end
    end
  end
end
