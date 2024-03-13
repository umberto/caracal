require 'caracal/core/models/base_model'
require 'caracal/core/models/border_model'
require 'caracal/core/models/table_cell_model'
require 'caracal/core/models/table_look_model'

module Caracal
  module Core
    module Models

      # This class handles block options passed to the table
      # method.
      class TableModel < BaseModel
        use_prefix :table

        has_string_attribute :caption, default: 'TableNormal'
        has_string_attribute :style, default: 'TableNormal'
        has_string_attribute :border_color, default: 'auto'
        has_string_attribute :layout, default: 'auto'
        has_string_attribute :bgcolor
        has_string_attribute :bgstyle, default: 'clear'

        has_symbol_attribute :align, default: :center
        has_symbol_attribute :border_line, default: :single

        has_integer_attribute :border_size, default: 0
        has_integer_attribute :border_spacing, default: 0
        has_integer_attribute :repeat_header, default: 0
        has_integer_attribute :row_band_size, default: 1
        has_integer_attribute :col_band_size, default: 1
        has_integer_attribute :width
        has_integer_attribute :indent

        has_model_attribute :look,
            model: Caracal::Core::Models::TableLookModel,
            default: Caracal::Core::Models::TableLookModel.new

        # accessors
        attr_reader :table_border_top         # returns border model
        attr_reader :table_border_bottom      # returns border model
        attr_reader :table_border_left        # returns border model
        attr_reader :table_border_right       # returns border model
        attr_reader :table_border_horizontal  # returns border model
        attr_reader :table_border_vertical    # returns border model
        attr_reader :table_column_widths


        # initialization
        def initialize(options={}, &block)
          @document             = options.delete :document
          @table_style          = DEFAULT_TABLE_STYLE
          @table_align          = DEFAULT_TABLE_ALIGN
          @table_border_color   = DEFAULT_TABLE_BORDER_COLOR
          @table_border_line    = DEFAULT_TABLE_BORDER_LINE
          @table_border_size    = DEFAULT_TABLE_BORDER_SIZE
          @table_border_spacing = DEFAULT_TABLE_BORDER_SPACING
          @table_repeat_header  = DEFAULT_TABLE_REPEAT_HEADER
          @table_row_band_size  = DEFAULT_TABLE_ROW_BAND_SIZE
          @table_col_band_size  = DEFAULT_TABLE_COL_BAND_SIZE
          @table_layout         = DEFAULT_TABLE_LAYOUT
          @table_look           = DEFAULT_TABLE_LOOK

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== DATA ACCESSORS =======================

        def table_align
          case @table_align
          when :left
            :start
          when :right
            :end
          else
            @table_align
          end
        end

        def cells
          rows.flatten
        end

        def cols
          @cols ||= rows.reduce([]) do |array, row|
            row.each_with_index do |cell, index|
              array[index]  = []  if array[index].nil?
              array[index] << cell
            end
            array
          end
        end

        def rows
          @table_data || [[]]
        end


        #=============== STYLES ===============================

        # This method sets explicit widths on all wrapped cells
        # that do not already have widths asided.
        #
        def calculate_width(container_width)
          width(container_width) unless table_width.to_i > 0

          cells.each { |c| c.calculate_width(default_cell_width) }
        end

        # This method allows tables to be styled several cells
        # at a time.
        #
        # For example, this would style a header row.
        #
        # docx.table data do |t|
        #   t.cell_style t.rows[0], background: '3366cc', color: 'ffffff', bold: true
        #   t.cell_style t.rows[2], style: 'MyTableRowStyle'
        # end
        #
        # where 'MyTableRowStyle' is a style with type 'table_row'
        #
        def cell_style(models, options={})
          styles = merge_named_styles(options)

          [models].flatten.compact.each do |m|
            m.apply_styles styles
          end
        end


        #=============== GETTERS ==============================

        # border attrs
        [:top, :bottom, :left, :right, :horizontal, :vertical].each do |m|
          [:color, :line, :size, :spacing].each do |attr|
            define_method "table_border_#{ m }_#{ attr }" do
              model = send("table_border_#{ m }")
              value = (model) ? model.send("border_#{ attr }") : send("table_border_#{ attr }")
            end
          end

          define_method "table_border_#{ m }_total_size" do
            model = send("table_border_#{ m }")
            value = (model) ? model.total_size : table_border_size + (2 * table_border_spacing)
          end
        end


        #=============== SETTERS ==============================

        # models
        [:top, :bottom, :left, :right, :horizontal, :vertical].each do |m|
          define_method "border_#{ m }" do |options = {}, &block|
            options.merge!({ type: m })
            instance_variable_set "@table_border_#{ m }", Caracal::Core::Models::BorderModel.new(options, &block)
          end
        end

        # column widths
        def column_widths(value)
          @table_column_widths = value.map &:to_i if value.is_a? Array
        end

        # .data
        def data(value)
          begin
            @table_data = value.map do |data_row|
              data_row.map do |data_cell|
                case data_cell
                when Caracal::Core::Models::TableCellModel
                  if data_cell.cell_style
                    data_cell.apply_styles merge_named_styles(style: data_cell.cell_style)
                  end
                  data_cell
                when Hash
                  Caracal::Core::Models::TableCellModel.new merge_named_styles(data_cell)
                when Proc
                  Caracal::Core::Models::TableCellModel.new &data_cell
                else
                  Caracal::Core::Models::TableCellModel.new content: data_cell.to_s
                end
              end
            end
          #rescue
            #raise Caracal::Errors::InvalidTableDataError, 'Table data must be a two-dimensional array.'
          end
        end

        #=============== VALIDATION ==============================

        def valid?
          cells.first.is_a?(Caracal::Core::Models::TableCellModel)
        end

        private

        # FIXME: needs to be replaced with proper handling of multiple table styles
        def merge_named_styles(options)
          named_style = options.delete(:style)
          if named_style
            raise "If you use cell styles, you must create the table using #table" unless @document
            ns = @document.styles.find{|s| s.style_id == named_style }
            raise "style #{named_style} is not available in document" unless ns
            raise "style #{named_style} is a #{ns.style_type} but should be a table, table_cell, or table_row style" unless %w(table table_row table_cell).include?(ns.style_type)
            ns.to_h.merge options.compact
          else
            options.compact
          end
        end

        def default_cell_width
          cell_widths     = rows.first.map { |c| c.cell_width.to_i }
          remaining_width = table_width - cell_widths.reduce(&:+).to_i
          remaining_cols  = cols.size - cell_widths.reject { |w| w == 0 }.size
          default_width   = (remaining_cols == 0) ? 0 : (remaining_width / remaining_cols)
        end

        def option_keys
          k = []
          k << [:data, :align, :width, :style, :layout, :bgcolor, :bgstyle, :caption, :indent]
          k << [:border_color, :border_line, :border_size, :border_spacing]
          k << [:border_bottom, :border_left, :border_right, :border_top, :border_horizontal, :border_vertical]
          k << [:column_widths]
          k << [:repeat_header, :row_band_size, :col_band_size]
          k.flatten
        end

      end

    end
  end
end
