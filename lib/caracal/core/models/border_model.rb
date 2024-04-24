require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models

      # This class handles block options passed to the page margins
      # method.
      class BorderModel < BaseModel
        ATTRS = [:color, :theme_color, :line, :size, :spacing].freeze
        TYPES = [:top, :bottom, :left, :right, :horizontal, :vertical].freeze

        use_prefix :border

        has_string_attribute :color, default: 'auto'

        has_model_attribute :theme_color,
            model: Caracal::Core::Models::ThemeColorModel

        has_symbol_attribute :line
        has_symbol_attribute :type

        has_integer_attribute :size    # 1/8 points
        has_integer_attribute :spacing # 1/8 points

        # initialization
        def initialize(options={}, &block)
          @border_type = DEFAULT_BORDER_TYPE

          ATTRS.each do |attr|
            instance_variable_set "@border_#{attr}", self.class.const_get("DEFAULT_BORDER_#{attr.to_s.upcase}")
          end

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
          self.class.formatted_type(border_type) || ''
        end

        def total_size
          if undefined?
            0
          else
            border_size + (2 * border_spacing)
          end
        end

        #=============== VALIDATION ==============================

        def valid?
          dims = [:size, :spacing]
          (undefined? or dims.all? {|d| validate_size d, at_least: 0, allow_nil: true }) and
              validate_inclusion :type, within: TYPES, allow_nil: true
        end

        def undefined?
          self.border_line == :none or self.border_line.nil?
        end

        private

        def option_keys
          ATTRS + [:type]
        end

      end
    end
  end
end
