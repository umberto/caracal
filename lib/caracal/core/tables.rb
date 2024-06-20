# frozen_string_literal: true

require 'caracal/core/models/table_model'
require 'caracal/errors'

module Caracal
  module Core
    # This module encapsulates all the functionality related to adding tables
    # to the document.
    module Tables
      def self.included(base)
        base.class_eval do
          def table(*args, &block)
            options = Caracal::Utilities.extract_options! args
            options.merge! data: args.first if args.first

            table_model = Caracal::Core::Models::TableModel.new options.merge(document: @document || self), &block

            if respond_to? :page_width
              available_container_width = page_width - page_margin_left - page_margin_right
              table_model.calculate_width available_container_width, self
            end

            raise Caracal::Errors::InvalidModelError, table_model.errors.inspect unless table_model.valid?

            contents << table_model

            table_model
          end
        end
      end
    end
  end
end
