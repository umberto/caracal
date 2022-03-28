module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed for functions that
      # do not store or manipulate data.
      #
      class BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        attr_reader :alignment

        # initialization
        def initialize(options={}, &block)
          @alignment = options.key?(:align) && [:left, :center, :right].include?(options[:align]) ? options[:align] : nil
          options.each do |(key, value)|
            send(key, value) if option_keys.include?(key)
          end

          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
        end


        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------

        #=============== VALIDATION ===========================

        def valid?
          true
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          []
        end

      end

    end
  end
end
