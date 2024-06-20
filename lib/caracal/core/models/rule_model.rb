# frozen_string_literal: true

require 'caracal/core/models/border_model'

module Caracal
  module Core
    module Models
      # This class handles block options passed to the page margins
      # method.
      #
      class RuleModel < BorderModel
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # aliases
        alias rule_color border_color
        alias rule_size border_size
        alias rule_spacing border_spacing
        alias rule_line border_line
      end
    end
  end
end
