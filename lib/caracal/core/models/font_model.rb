require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # font data.
      class FontModel < BaseModel
        use_prefix :font

        has_string_attribute :name

        #=============== STATE ================================

        def matches?(str)
          font_name.to_s.downcase == str.to_s.downcase
        end

        #=============== VALIDATION ===========================

        def valid?
          validate_presence :name
        end

        private

        def option_keys
          [:name]
        end

      end
    end
  end
end
