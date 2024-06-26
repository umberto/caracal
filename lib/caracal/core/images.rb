# frozen_string_literal: true

require 'caracal/core/models/image_model'
require 'caracal/errors'

module Caracal
  module Core
    # This module encapsulates all the functionality related to adding
    # images to the document.
    #
    module Images
      def self.included(base)
        base.class_eval do
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def img(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!(url: args.first) if args.first

            model = Caracal::Core::Models::ImageModel.new(options, &block)
            unless model.valid?
              raise Caracal::Errors::InvalidModelError, 'Images require an URL and positive size/margin values.'
            end

            contents << model

            model
          end
        end
      end
    end
  end
end
