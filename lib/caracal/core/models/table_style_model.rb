require 'caracal/core/models/style_model'

module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # taple style data and conditional formating.
      class TableStyleModel < StyleModel
        TABLE_STYLE_VALID_CONDITIONAL_FORMAT_TYPES = %w(wholeTable band1Horz band1Vert band2Horz band2Vert firstCol firstRow lastCol lastRow neCell nwCell seCell swCell)
        DEFAULT_STYLE_TYPE = 'table'
        VERTICAL_ALIGNS = %i(top center bottom)

        use_prefix :style

        has_integer_attribute :col_band_size, default: 1
        has_integer_attribute :row_band_size, default: 1
        has_integer_attribute :cell_spacing, default: 0

        has_symbol_attribute :vertical_align, default: :top

        # initialization
        def initialize(options = {}, &block)
          @style_default = false
          @conditional_formats = {}
          @cell_vertical_align = DEFAULT_STYLE_VERTICAL_ALIGN
          @style_row_band_size = DEFAULT_STYLE_ROW_BAND_SIZE
          @style_col_band_size = DEFAULT_STYLE_COL_BAND_SIZE
          super options, &block
        end

        def conditional_format(options, &block)
          @conditional_formats[options[:type]] = Caracal::Core::Models::TableStyleModel.new(options, &block)
        end

        def conditional_formats
          @conditional_formats.values
        end

        def type(value)
          allowed     = %w(character paragraph table table_row table_cell)
          allowed    += TABLE_STYLE_VALID_CONDITIONAL_FORMAT_TYPES
          given       = value.to_s.strip
          @style_type = allowed.include?(given) ? given : DEFAULT_STYLE_TYPE
        end

        def valid?
          super and self.conditional_formats.all? &:valid?
        end
      end

    end
  end
end
