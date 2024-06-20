# frozen_string_literal: true

require 'caracal/core/models/rule_model'
require 'caracal/errors'

module Caracal
  module Core
    # This module encapsulates all the functionality related to adding
    # horizontal rules to the document.
    #
    module Rules
      def self.included(base)
        base.class_eval do
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def hr(options = {}, &block)
            model = Caracal::Core::Models::RuleModel.new(options, &block)

            unless model.valid?
              raise Caracal::Errors::InvalidModelError, 'Horizontal rules require non-zero :size and :spacing values.'
            end

            contents << model

            model
          end
        end
      end
    end
  end
end
