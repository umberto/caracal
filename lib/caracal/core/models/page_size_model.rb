# frozen_string_literal: true

require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models
      # This class handles block options passed to the page size
      # method.
      #
      class PageSizeModel < BaseModel
        use_prefix :page

        has_integer_attribute :width,  default: 12_240 #  8.5in in twips
        has_integer_attribute :height, default: 15_840 # 11.0in in twips

        has_string_attribute :orientation, default: 'portrait'

        # initialization
        def initialize(options = {}, &block)
          @page_width       = DEFAULT_PAGE_WIDTH
          @page_height      = DEFAULT_PAGE_HEIGHT
          @page_orientation = DEFAULT_PAGE_ORIENTATION

          super options, &block
        end

        #=============== SETTERS ==============================

        def orientation(value)
          allowed = %w[landscape portrait]
          given   = value.to_s.downcase
          @page_orientation = allowed.include?(given) ? given : 'portrait'
        end

        #=============== VALIDATION ==============================

        def valid?
          %i[width height].all? { |a| validate_size a, at_least: 0 }
        end

        private

        def option_keys
          %i[width height orientation]
        end
      end
    end
  end
end
