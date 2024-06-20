# frozen_string_literal: true

require 'caracal/core/models/base_model'
require 'caracal/core/models/border_model'
require 'caracal/core/models/paragraph_model'
require 'caracal/core/models/has_background'
require 'caracal/core/models/has_color'
require 'caracal/core/models/has_borders'
require 'caracal/core/models/has_run_attributes'

module Caracal
  module Core
    module Models
      # This class handles block options passed to tables via their data collections.
      class TableCellModel < BaseModel
        use_prefix :cell

        include HasRunAttributes
        extend HasMargins

        has_margins top: 40, left: 40, right: 40, bottom: 0

        has_string_attribute :style

        has_symbol_attribute :align # paragraph attr
        has_symbol_attribute :content_vertical_align

        has_integer_attribute :colspan, default: 1
        has_integer_attribute :rowspan, default: 1
        has_integer_attribute :width

        attr_accessor :document, :table_ref

        # initialization
        def initialize(options = {}, &block)
          @document            = options.delete :document
          @table_ref           = options.delete :table_ref
          @cell_rowspan        = DEFAULT_CELL_ROWSPAN
          @cell_colspan        = DEFAULT_CELL_COLSPAN
          @cell_top            = DEFAULT_CELL_TOP
          @cell_left           = DEFAULT_CELL_LEFT
          @cell_right          = DEFAULT_CELL_RIGHT
          @cell_bottom         = DEFAULT_CELL_BOTTOM
          @cell_content_vertical_align = DEFAULT_CELL_CONTENT_VERTICAL_ALIGN
          initialize_run_attributes

          make_content = false
          if (content = options.delete(:content))
            if content.is_a? BaseModel
              contents << content
            elsif content.is_a? Array
              content.each do |c|
                unless c.is_a? BaseModel
                  raise "Content must be < Caracal::Core::Models::BaseModel but is #{content.inspect}"
                end

                contents << c
              end
            else
              make_content = true
            end
          end

          super options, &block

          if make_content
            self.p content, paragraph_attributes.merge(run_attributes.to_h)
          else
            # the final tag in a table cell *must* be a paragraph for OOXML to not throw an error.
            p_klass = Caracal::Core::Models::ParagraphModel
            contents << p_klass.new(paragraph_attributes.merge(content: '')) unless contents.last.is_a? p_klass
          end
        end

        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== DATA ACCESSORS =======================

        def contents
          @contents ||= []
        end

        #=============== STYLES ===============================

        # This method allows styles to be applied to this cell
        # from the table level.  It attempts to add the style
        # first to the instance, and then to any sub-models that
        # respond to the method.
        #
        # In all cases, invalid options will simply be ignored.
        #
        def apply_styles(opts = {}, reverse: false)
          # make dup of options so we don't
          # harm args sent to sibling cells
          options = opts.dup

          # first, try apply to self
          options.each do |k, v|
            next unless respond_to? k

            send k, v if !reverse || send("cell_#{k}").nil?
            options.delete k if %i[top bottom left right].include?(k.to_sym) || k.to_s.include?('border')
          end

          # then, try apply to contents
          contents.each do |model|
            options.each do |k, v|
              pa = model.respond_to?(:paragraph_attributes) ? model.paragraph_attributes : {}
              if model.respond_to?(k) && !(pa[k])
                model.send k, v
                # options.delete k unless HasRunAttributes::ATTRS.include? k
              end
            end

            # finally, apply to runs. options do trickle down
            # because paragraph-level styles don't affect runs within tables.
            # only sets options on runs that don't have that option already set.
            next unless model.respond_to? :runs

            model.runs.each do |run|
              ra = run.respond_to?(:run_attributes) ? run.run_attributes : {}
              options.each do |k, v|
                run.send k, v if run.respond_to?(k) && !(ra[k])
              end
            end
          end
        end

        def relevant_cell_style(container)
          if cell_style
            @relevant_cell_style = container.find_style cell_style
          elsif container.table_style
            @relevant_cell_style = container.find_style container.table_style
          end
        end

        def calculate_width(default_width, container)
          # return unless self.cell_width.to_i > 0
          width default_width unless cell_width.to_i.positive?

          # raise container.inspect # use to determine currently active style, then extract left and right
          l = cell_left  || relevant_cell_style(container)&.style_left || 0
          r = cell_right || relevant_cell_style(container)&.style_right || 0
          available_container_width = cell_width - l - r

          contents.each do |model|
            if model.respond_to? :calculate_width
              model.calculate_width available_container_width, container # FIXME: disabled for debugging
            end
          end
        end

        def find_style(*args)
          document.find_style(*args)
        end

        def paragraph_attributes
          {
            align: cell_align
          }.compact
        end

        def cnf_style(table_ref, row, col)
          current_table_style = document.find_style table_ref.table_style
          return unless current_table_style

          ConditionalFormat.new current_table_style, table_ref.table_look,
                                row: row,
                                col: col,
                                rows: table_ref.rows.size,
                                cols: table_ref.rows.map(&:size).max
        end

        #=============== VALIDATION ===========================

        def valid?
          validate_size :width, at_least: 0, allow_nil: true and
            validate_inclusion :content_vertical_align, within: %i[top bottom center], allow_nil: true and
            valid_bgstyle? and
            validate('must at least contain one content element') { contents.size.positive? } and
            valid_run_attributes?
        end

        def self.option_keys
          @option_keys ||= %i[style width align content_vertical_align rowspan colspan] +
                           HasMargins::ATTRS +
                           HasRunAttributes::ATTRS
        end

        private

        def option_keys
          self.class.option_keys
        end
      end

      class ConditionalFormat
        BITMASK = {
          firstRow: 0,
          lastRow: 0,
          firstCol: 0,
          lastCol: 0,
          band1Vert: 0,
          band2Vert: 0,
          band1Horz: 0,
          band2Horz: 0,
          neCell: 0,
          nwCell: 0,
          seCell: 0,
          swCell: 0
        }.freeze

        attr_reader :table_style

        def initialize(table_style, table_look, rows: nil, cols: nil, row: nil, col: nil)
          @table_style = table_style
          @table_look = table_look
          @rows = rows
          @row = row
          @cols = cols
          @col = col
          set_bitmask
        end

        def bitmask
          @bm.values.join ''
        end

        def style_hash
          hsh = @table_style.table_cell_style_attributes
          if @table_style.respond_to? :find_conditional_format
            { wholeTable: 1 }.merge(@bm).each do |key, use|
              cf = @table_style.find_conditional_format key
              hsh.merge! cf.table_cell_style_attributes if (use == 1) && cf
            end
          end
          hsh
        end

        private

        def set_bitmask
          max_row = @rows - 1
          max_col = @cols - 1
          @bm = BITMASK.dup
          if @table_look.table_look_first_row && @row.zero?
            @bm[:firstRow] = 1
            @bm[:nwCell] = 1 if @table_look.table_look_first_col && @col.zero?
            @bm[:neCell] = 1 if @table_look.table_look_last_col && (@col == max_col)
          end

          if @table_look.table_look_last_row && (@row == max_row)
            @bm[:lastRow] = 1
            @bm[:swCell] = 1 if @table_look.table_look_first_col && @col.zero?
            @bm[:seCell] = 1 if @table_look.table_look_last_col && (@col == max_col)
          end

          @bm[:firstCol] = 1 if @table_look.table_look_first_col && @col.zero?

          @bm[:lastCol] = 1 if @table_look.table_look_last_col && (@col == max_col)

          # TODO: hband, vband
          @bm
        end
      end
    end
  end
end
