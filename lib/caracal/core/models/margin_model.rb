# frozen_string_literal: true

require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models
      # This class handles block options passed to the margins
      # method.
      #
      class MarginModel < BaseModel
        use_prefix :margin

        has_integer_attribute :top,    default: 0
        has_integer_attribute :bottom, default: 0
        has_integer_attribute :left,   default: 0
        has_integer_attribute :right,  default: 0

        # initialization
        def initialize(options = {}, &block)
          @margin_top    = DEFAULT_MARGIN_TOP
          @margin_bottom = DEFAULT_MARGIN_BOTTOM
          @margin_left   = DEFAULT_MARGIN_LEFT
          @margin_right  = DEFAULT_MARGIN_RIGHT

          super options, &block
        end

        #=============== VALIDATION ==============================

        def valid?
          %i[bottom left right top].all? { |a| validate_size a, at_least: 0 }
        end

        private

        def option_keys
          %i[top bottom left right]
        end
      end
    end
  end
end
