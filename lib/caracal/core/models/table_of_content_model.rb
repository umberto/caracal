require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # table of contents data.
      #
      class TableOfContentModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # constants
        const_set(:DEFAULT_START_LEVEL, 1)
        const_set(:DEFAULT_END_LEVEL,   3)

        # accessors
        attr_reader :toc_legend
        attr_reader :toc_start_level
        attr_reader :toc_end_level

        # initialization
        def initialize(options={}, &block)
          @toc_start_level = DEFAULT_START_LEVEL
          @toc_end_level = DEFAULT_END_LEVEL

          super options, &block
        end

        #--------------------------------------------------
        # Public Instance Methods
        #--------------------------------------------------

        #========== SETTERS ===============================

        # integers
        [:start_level, :end_level].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@toc_#{ m }", value.to_i)
          end
        end
        
        # strings
        [:legend].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@toc_#{ m }", value.to_s)
          end
        end

        #========== STATE HELPER ===========================

        def legend?
          return false if toc_legend.nil?

          !toc_legend.strip == ''
        end

        #========== VALIDATION ============================

        def valid?
          [:start_level, :end_level].each do |method|
            value = send("toc_#{method}")
            return false if value <= 0 || value > 6

          end
          toc_start_level <= toc_end_level
        end


        #--------------------------------------------------
        # Private Instance Methods
        #--------------------------------------------------
        private

        def option_keys
          [:legend, :start_level, :end_level]
        end

      end

    end
  end
end
