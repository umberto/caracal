# frozen_string_literal: true

require 'caracal/core/models/list_model'
require 'caracal/core/models/paragraph_model'
require 'caracal/errors'

module Caracal
  module Core
    module Models
      # This class encapsulates the logic needed to store and manipulate
      # list item data.
      class ListItemModel < ParagraphModel
        use_prefix :list_item

        has_integer_attribute :level
        has_symbol_attribute :type

        # accessors
        attr_accessor :nested_list

        # readers (create aliases for superclass methods to conform
        # to expected naming convention.)
        (ParagraphModel.option_keys - %i[content]).each do |attr|
          alias_method :"list_item_#{attr}", :"paragraph_#{attr}"
        end

        #=============== SUB-METHODS ===========================

        def ol(options = {}, &block)
          options.merge! type: :ordered, level: list_item_level + 1

          model = Caracal::Core::Models::ListModel.new(options, &block)
          raise Caracal::Errors::InvalidModelError, model.errors.inspect unless model.valid?

          @nested_list = model

          model
        end

        def ul(options = {}, &block)
          options.merge! type: :unordered, level: list_item_level + 1

          model = Caracal::Core::Models::ListModel.new(options, &block)
          raise Caracal::Errors::InvalidModelError, model.errors.inspect unless model.valid?

          @nested_list = model

          model
        end

        #=============== VALIDATION ===========================

        def valid?
          super and %i[type level].all? { |a| validate_presence a } and !runs.empty?
        end

        private

        def option_keys
          super + %i[type level]
        end
      end
    end
  end
end
