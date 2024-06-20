# frozen_string_literal: true

require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models
      # This class handles block options passed to the look
      # method.
      #
      class TableLookModel < BaseModel
        use_prefix :table_look

        has_boolean_attribute :first_row, default: false
        has_boolean_attribute :last_row, default: false
        has_boolean_attribute :first_col, default: false
        has_boolean_attribute :last_col, default: false
        has_boolean_attribute :hband, default: true
        has_boolean_attribute :vband, default: true

        def initialize(options = {}, &block)
          @table_look_first_row = DEFAULT_TABLE_LOOK_FIRST_ROW
          @table_look_last_row  = DEFAULT_TABLE_LOOK_LAST_ROW
          @table_look_first_col = DEFAULT_TABLE_LOOK_FIRST_COL
          @table_look_last_col  = DEFAULT_TABLE_LOOK_LAST_COL
          @table_look_hband     = DEFAULT_TABLE_LOOK_HBAND
          @table_look_vband     = DEFAULT_TABLE_LOOK_VBAND

          super options, &block
        end

        #=============== GETTERS ==============================

        def table_look_no_hband
          !@table_look_hband
        end

        def table_look_no_vband
          !@table_look_vband
        end

        #=============== SETTERS ==============================

        def nw_cell(value)
          @table_look_first_row = @table_look_first_col = value
        end

        def ne_cell(value)
          @table_look_first_row = @table_look_last_col = value
        end

        def sw_cell(value)
          @table_look_last_row = @table_look_first_col = value
        end

        def se_cell(value)
          @table_look_last_row = @table_look_last_col = value
        end

        def no_hband(value)
          @table_look_hband = !value
        end

        def no_vband(value)
          @table_look_vband = !value
        end

        #=============== VALIDATION ==============================

        def valid?
          option_keys.all? { |o| validate_inclusion o, within: [true, false, nil] }
        end

        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          %i[first_col last_col first_row last_row hband vband no_hband no_vband]
        end
      end
    end
  end
end
