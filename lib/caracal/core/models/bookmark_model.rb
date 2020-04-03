require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # bookmarks.
      #
      class BookmarkModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # accessors
        attr_reader :bookmark_start
        attr_reader :bookmark_id
        attr_reader :bookmark_name


        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #========== GETTERS ===============================

        # .run_attributes
        def run_attributes
          {
            start:          bookmark_start,
            id:             bookmark_id,
            name:           bookmark_name
          }
        end


        #========== SETTERS ===============================

        # booleans
        [:start].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@bookmark_#{ m }", !!value)
          end
        end

        # strings
        [:name].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@bookmark_#{ m }", value.to_s)
          end
        end

        #========== STATE HELPERS =========================

        def start?
          !!bookmark_start
        end


        #========== VALIDATION ============================

        def valid?
          start? ? !bookmark_name.to_s.strip.empty? : true
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [:name, :start]
        end

      end

    end
  end
end
