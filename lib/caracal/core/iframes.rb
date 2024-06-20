# frozen_string_literal: true

require 'caracal/core/models/iframe_model'
require 'caracal/errors'

module Caracal
  module Core
    # This module encapsulates all the functionality related to inserting
    # word document snippets into the document.
    #
    module IFrames
      def self.included(base)
        base.class_eval do
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def iframe(options = {}, &block)
            model = Caracal::Core::Models::IFrameModel.new(options.merge(document: self), &block)
            raise Caracal::Errors::InvalidModelError, model.errors.inspect unless model.valid?

            model.preprocess!
            model.namespaces.each do |(prefix, href)|
              namespace prefix: prefix, href: href
            end

            model.ignorables.each do |prefix|
              ignorable(prefix)
            end

            contents << model

            model
          end
        end
      end
    end
  end
end
