# frozen_string_literal: true

require 'caracal/core/models/relationship_model'
require 'caracal/errors'

module Caracal
  module Core
    # This module encapsulates all the functionality related to registering and
    # retrieving relationships.
    #
    module Relationships
      def self.included(base)
        base.class_eval do
          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------

          attr_reader :relationship_counter

          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------

          def self.default_relationships
            [
              { target: 'fontTable.xml',  type: :font      },
              { target: 'footer1.xml',    type: :footer,   if: :page_number_show },
              { target: 'numbering.xml',  type: :numbering },
              { target: 'settings.xml',   type: :setting   },
              { target: 'styles.xml',     type: :style     }
            ]
          end

          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          #============== ATTRIBUTES ==========================

          def relationship(options = {}, &block)
            return if find_relationship options[:key] # FIXME: this only takes the key into account, not the type

            id = relationship_counter.to_i + 1
            options = options.merge id: id

            model = Caracal::Core::Models::RelationshipModel.new options, &block
            raise Caracal::Errors::InvalidModelError, model.errors.inspect unless model.valid?

            @relationship_counter = id
            register_relationship model
          end

          #============== GETTERS =============================

          def relationships
            @relationships ||= []
          end

          def find_relationship(target)
            relationships.find { |r| r.matches? target }
          end

          def relationships_by_type(type)
            relationships.select { |r| r.relationship_type == type.to_sym }
          end

          #============== REGISTRATION ========================

          def register_relationship(model)
            if (r = find_relationship(model.relationship_target))
              # ignore already registered relationships
            else
              relationships << model
              r = model
            end
            r
          end

          def unregister_relationship(target)
            return unless (r = find_relationship(target))

            relationships.delete(r)
          end
        end
      end
    end
  end
end
