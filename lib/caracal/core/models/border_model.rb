require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models

      # This class handles block options passed to the page margins
      # method.
      class BorderModel < BaseModel
        use_prefix :border

        has_string_attribute :color, default: 'auto'

        has_symbol_attribute :line, default: :single
        has_symbol_attribute :type, default: :top

        has_integer_attribute :size, default: 4 # 0.5pt in 1/8 points
        has_integer_attribute :spacing, default: 1 # 0.125pt in 1/8 points

        # initialization
        def initialize(options={}, &block)
          @border_color   = DEFAULT_BORDER_COLOR
          @border_line    = DEFAULT_BORDER_LINE
          @border_size    = DEFAULT_BORDER_SIZE
          @border_spacing = DEFAULT_BORDER_SPACING
          @border_type    = DEFAULT_BORDER_TYPE

          super options, &block
        end


        #-------------------------------------------------------------
        # Class Methods
        #-------------------------------------------------------------

        def self.formatted_type(type)
          {
            horizontal: 'insideH',
            vertical:   'insideV',
            top:        'top',
            bottom:     'bottom',
            left:       'left',
            right:      'right'
          }[type.to_s.to_sym]
        end

        #=============== GETTERS ==============================

        def formatted_type
          self.class.formatted_type(border_type)
        end

        def total_size
          border_size + (2 * border_spacing)
        end

        #=============== VALIDATION ==============================

        def valid?
          dims = [border_size, border_spacing]
          dims.all? { |d| d > 0 }
        end

        private

        def option_keys
          [:color, :line, :size, :spacing, :type]
        end

      end
    end
  end
end
