# frozen_string_literal: true

require 'caracal/core/models/style_model'

module Caracal
  module Core
    module Models
      # This class encapsulates the logic needed to store and manipulate
      # taple style data and conditional formating.
      class TableStyleModel < StyleModel
        CONDITIONAL_FORMAT_TYPES = %i[wholeTable band1Horz band1Vert band2Horz band2Vert firstCol firstRow lastCol
                                      lastRow neCell nwCell seCell swCell].freeze
        CONTENT_VERTICAL_ALIGNS  = %i[top center bottom].freeze

        DEFAULT_STYLE_TYPE = :table
        DEFAULT_STYLE_BASE = 'TableNormal'

        use_prefix :style

        has_integer_attribute :col_band_size, default: 1
        has_integer_attribute :row_band_size, default: 1
        has_integer_attribute :cell_spacing

        has_symbol_attribute :content_vertical_align # , default: :top

        def initialize(options = {}, &block)
          @_conditional                 = options.delete :conditional
          @style_default                = false
          @conditional_formats          = nil
          @style_col_band_size          = DEFAULT_STYLE_COL_BAND_SIZE
          @style_row_band_size          = DEFAULT_STYLE_ROW_BAND_SIZE
          @style_cell_spacing           = DEFAULT_STYLE_CELL_SPACING
          @style_content_vertical_align = DEFAULT_STYLE_CONTENT_VERTICAL_ALIGN
          # @style_margins                = DEFAULT_STYLE_MARGINS
          super options, &block
        end

        def conditional_format(options, &block)
          @conditional_formats ||= {}
          model = Caracal::Core::Models::TableStyleModel.new options.merge(conditional: true), &block
          raise Caracal::Errors::InvalidModelError, model.errors.inspect unless model.valid?

          @conditional_formats[options[:type]] = model
        end

        def conditional_formats
          @conditional_formats&.values
        end

        def find_conditional_format(name)
          @conditional_formats[name.to_s]
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
            vertical_align: style_vertical_align
            # highlight_color: self.style_highlight_color
          }.compact
          OpenStruct.new attrs
        end

        # attributes that cannot be set via table styles and have to be set for each cell separately.
        def table_cell_style_attributes
          hsh = super
          %i[content_vertical_align].inject({}) do |_h, k|
            v = send "#{self.class.attr_prefix}_#{k}"
            hsh[k] = v unless v.nil?
          end
          hsh
        end

        def valid_type?
          if @_conditional
            validate_inclusion :type, within: CONDITIONAL_FORMAT_TYPES
          else
            super
          end
        end
      end
    end
  end
end
