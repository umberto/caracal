# frozen_string_literal: true

require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models
      # This class handles block options passed to the page_numbers
      # method.
      #
      class PageNumberModel < BaseModel
        use_prefix :page_number

        has_symbol_attribute :align, default: :center
        has_boolean_attribute :show, default: false
        has_string_attribute :label
        has_integer_attribute :label_size  # in pt
        has_integer_attribute :number_size # in pt

        PAGE_NUMBER_ALIGNS = %i[left center right].freeze

        # initialization
        def initialize(options = {}, &block)
          @page_number_align        = DEFAULT_PAGE_NUMBER_ALIGN
          @page_number_label        = DEFAULT_PAGE_NUMBER_LABEL
          @page_number_label_size   = DEFAULT_PAGE_NUMBER_LABEL_SIZE
          @page_number_number_size  = DEFAULT_PAGE_NUMBER_NUMBER_SIZE
          @page_number_show         = DEFAULT_PAGE_NUMBER_SHOW

          super options, &block
        end

        #=============== SETTERS ==============================

        def label(value)
          @page_number_label = value.to_s.strip # renderer will enforce trailing space
        end

        def label_size(value)
          v = value.to_i
          @page_number_label_size = v.zero? ? nil : v
        end

        def number_size(value)
          v = value.to_i
          @page_number_number_size = v.zero? ? nil : v
        end

        def size(value)
          label_size value
          number_size value
        end

        #=============== VALIDATION ===========================

        def valid?
          !page_number_show or validate_inclusion :align, within: PAGE_NUMBER_ALIGNS
        end

        private

        def option_keys
          %i[align label label_size number_size show]
        end
      end
    end
  end
end
