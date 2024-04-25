require 'caracal/core/models/base_model'
require 'caracal/core/models/border_model'
require 'caracal/core/models/paragraph_model'
require 'caracal/core/models/has_background'
require 'caracal/core/models/has_borders'


module Caracal
  module Core
    module Models
      # This class handles block options passed to tables via their data collections.
      class TableCellModel < BaseModel
        use_prefix :cell

        include HasBackground
        include HasBorders
        extend HasMargins

        has_margins top: 100, left: 100, right: 100, bottom: 100

        has_string_attribute :style

        has_symbol_attribute :vertical_align
        has_symbol_attribute :content_vertical_align,  default: :top

        has_integer_attribute :colspan,        default: 1
        has_integer_attribute :rowspan,        default: 1
        has_integer_attribute :width

        # initialization
        def initialize(options={}, &block)
          @cell_rowspan        = DEFAULT_CELL_ROWSPAN
          @cell_colspan        = DEFAULT_CELL_COLSPAN
          @cell_top            = DEFAULT_CELL_TOP
          @cell_left           = DEFAULT_CELL_LEFT
          @cell_right          = DEFAULT_CELL_RIGHT
          @cell_bottom         = DEFAULT_CELL_BOTTOM
          @cell_content_vertical_align = DEFAULT_CELL_CONTENT_VERTICAL_ALIGN

          if content = options.delete(:content)
            if content.is_a? BaseModel
              self.contents << content
            elsif content.is_a? Array
              content.each do |c|
                if c.is_a? BaseModel
                  self.contents << c
                else
                  raise "Content must be < Caracal::Core::Models::BaseModel but is #{content.inspect}"
                end
              end
            else
              p content, options.dup #, &block
            end
          end

          super options, &block

          p_klass = Caracal::Core::Models::ParagraphModel     # the final tag in a table cell
          unless contents.last.is_a? p_klass                  # *must* be a paragraph for OOXML
            contents << p_klass.new(content: '')              # to not throw an error.
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
        def apply_styles(opts={})
          # make dup of options so we don't
          # harm args sent to sibling cells
          options = opts.dup

          # first, try apply to self
          options.each do |k, v|
            if respond_to? k
              send k, v
              options.delete k
            end
          end

          # # prevent top-level attrs from trickling down
          # options.delete_if { |(k,v)| option_keys.include?(k) }

          # then, try apply to contents
          contents.each do |model|
            options.each do |k,v|
              if model.respond_to?(k)
                model.send k, v
                options.delete k
              end
            end

            # finally, apply to runs. options do trickle down
            # because paragraph-level styles don't seem to
            # affect runs within tables. weirdsies.
            # only sets options on runs that don't have that option already set.
            if model.respond_to? :runs
              model.runs.each do |run|
                ra = run.respond_to?(:run_attributes) ? run.run_attributes : {}
                options.each do |k, v|
                  run.send(k, v) if run.respond_to?(k) and not ra[k]
                end
              end
            end
          end
        end

        def relevant_cell_style(container)
          if self.cell_style
            @relevant_cell_style = container.find_style self.cell_style
          elsif container.table_style
            @relevant_cell_style = container.find_style container.table_style
          else
             # TODO: handle conditional styles! => determine relevant table styles based on this cell's grid position
          end
        end

        def calculate_width(default_width, container)
          # return unless self.cell_width.to_i > 0
          self.width default_width unless self.cell_width.to_i > 0

          # raise container.inspect # use to determine currently active style, then extract left and right
          l = self.cell_left  || relevant_cell_style(container)&.style_left || 0
          r = self.cell_right || relevant_cell_style(container)&.style_right || 0
          available_container_width = self.cell_width - l - r

          contents.each do |model|
            if model.respond_to? :calculate_width
              model.calculate_width available_container_width, container # FIXME: disabled for debugging
            end
          end
        end


        #=============== VALIDATION ===========================

        def valid?
          validate_size :width, at_least: 0, allow_nil: true and
              self.valid_bgstyle? and
              self.validate('must at least contain one content element') { self.contents.size > 0 }
        end

        private

        def option_keys
          @options_keys ||= [:style, :width, :vertical_align, :content_vertical_align, :rowspan, :colspan] + HasBackground::ATTRS + HasBorders::ATTRS + HasMargins::ATTRS
        end
      end

    end
  end
end
