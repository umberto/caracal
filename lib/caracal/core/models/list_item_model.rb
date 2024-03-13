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
        alias_method :list_item_style,     :paragraph_style
        alias_method :list_item_color,     :paragraph_color
        alias_method :list_item_size,      :paragraph_size
        alias_method :list_item_bold,      :paragraph_bold
        alias_method :list_item_italic,    :paragraph_italic
        alias_method :list_item_underline, :paragraph_underline
        alias_method :list_item_bgcolor,   :paragraph_bgcolor

        #=============== SUB-METHODS ===========================

        def ol(options={}, &block)
          options.merge! type: :ordered, level: list_item_level + 1

          model = Caracal::Core::Models::ListModel.new(options, &block)
          if model.valid?
            @nested_list = model
          else
            raise Caracal::Errors::InvalidModelError, 'Ordered lists require at least one list item.'
          end
          model
        end

        def ul(options={}, &block)
          options.merge! type: :unordered, level: list_item_level + 1

          model = Caracal::Core::Models::ListModel.new(options, &block)
          if model.valid?
            @nested_list = model
          else
            raise Caracal::Errors::InvalidModelError, 'Unordered lists require at least one list item.'
          end
          model
        end

        #=============== VALIDATION ===========================

        def valid?
          a = [:type, :level]
          required = a.map { |m| send("list_item_#{ m }") }.compact.size == a.size
          required and !runs.empty?
        end

        private

        def option_keys
          [:type, :level, :content, :style, :color, :size, :bold, :italic, :underline, :bgcolor]
        end

      end
    end
  end
end
