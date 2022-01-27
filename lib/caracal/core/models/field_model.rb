module Caracal
  module Core
    module Models
      # This class encapsulates the logic needed to store and manipulate
      # fields.
      #
      class FieldModel < TextModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # accessors
        attr_reader :field_name

        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #========== GETTERS ===============================

        #========== SETTERS ===============================

        # strings
        [:name].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@field_#{ m }", value.to_s)
          end
        end

        #========== VALIDATION ============================

        def valid?
          a = [:name]
          a.map { |m| send("field_#{ m }") }.compact.size == a.size
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          super + [:name]
        end

        #def method_missing(method, *args, &block)
          # I'm on the fence with respect to this implementation. We're ignoring
          # :method_missing errors to allow syntax flexibility for paragraph-type
          # models.  The issue is the syntax format of those models--the way we pass
          # the content value as a special argument--coupled with the model's
          # ability to accept nested instructions.
          #
          # By ignoring method missing errors here, we can pass the entire paragraph
          # block in the initial, built-in call to :text.
        #end

      end

    end
  end
end
