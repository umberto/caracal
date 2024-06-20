# frozen_string_literal: true

module Caracal
  module Core
    module Models
      module HasMargins
        ATTRS = %i[top left right bottom].freeze

        def has_margins(top: nil, left: nil, right: nil, bottom: nil)
          has_integer_attribute :top,    default: top
          has_integer_attribute :left,   default: left
          has_integer_attribute :right,  default: right
          has_integer_attribute :bottom, default: bottom
        end
      end
    end
  end
end
