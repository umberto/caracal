require 'caracal/core/models/base_model'
require 'caracal/core/models/theme_model'

module Caracal
  module Core
    module Models

      class ThemeColorModel < BaseModel
        use_prefix :theme_color

        has_string_attribute :ref
        has_string_attribute :shade
        has_string_attribute :tint
        has_string_attribute :color, default: 'auto'

        def calculate_color(theme)
          # TODO: apply tint and shade, if present
          return nil
          # if self.theme_color_shade
          #   c = Chroma.paint("##{theme.send "theme_color_#{self.name}"}").hsl
          #   # c.spin(hex_to_angle(self.theme_color_tint))
          #   c.l = self.shade.hex
          #   c.to_rgb.sub '#', ''
          # else
          #   theme.send "theme_color_#{self.name}"
          # end
        end

        def theme_color_val
          self.theme_color_color
        end

        def valid?
          validate_presence :color and
              validate_inclusion :ref, within: ThemeModel::COLORS.map(&:to_s) + ['none'], allow_nil: false
        end


        private

        def option_keys
          [:ref, :tint, :shade, :color]
        end

        def hex_to_angle
          raise NotImplementedError
        end

      end
    end
  end
end
