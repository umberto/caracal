require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # paragraph style data.
      #
      class StyleModel < BaseModel
        use_prefix :style

        has_string_attribute :id
        has_string_attribute :name
        has_string_attribute :font
        has_string_attribute :type, default: 'paragraph'
        has_string_attribute :color, default: '333333'
        has_string_attribute :background
        has_string_attribute :base, default: 'Normal'
        has_string_attribute :next, default: 'Normal'

        has_integer_attribute :size, default: 20
        has_integer_attribute :line, default: 360 # 0.25in in twips
        has_integer_attribute :top          # twips
        has_integer_attribute :bottom       # twips
        has_integer_attribute :indent_left  # twips
        has_integer_attribute :indent_right # twips
        has_integer_attribute :indent_first # twips

        %w(top bottom left right).each do |dir|
          has_integer_attribute "margin_#{dir}" # twips
        end

        %w(top bottom left right horizontal vertical).each do |dir|
          has_integer_attribute "border_#{dir}_size"
          has_integer_attribute "border_#{dir}_spacing"

          has_string_attribute "border_#{dir}_color"
          has_string_attribute "border_#{dir}_style"
        end

        has_boolean_attribute :bold,      default: false
        has_boolean_attribute :italic,    default: false
        has_boolean_attribute :underline, default: false
        has_boolean_attribute :caps,      default: false
        has_boolean_attribute :default,   default: false
        has_boolean_attribute :keep_next
        has_boolean_attribute :keep_lines
        has_boolean_attribute :widow_control

        has_symbol_attribute :align, default: :left
        has_symbol_attribute :vertical_align, default: :baseline # subscript, superscript, baseline

        VERTICAL_ALIGNS = %i(subscript superscript baseline)

        # initialization
        def initialize(options={}, &block)
          @style_default = false
          @style_type    = DEFAULT_STYLE_TYPE
          @style_base    = DEFAULT_STYLE_BASE
          @style_next    = DEFAULT_STYLE_NEXT

          super options, &block

          if (style_id == DEFAULT_STYLE_BASE)
            @style_default       = true
            @style_color         ||= DEFAULT_STYLE_COLOR
            @style_size          ||= DEFAULT_STYLE_SIZE
            @style_bold          = DEFAULT_STYLE_BOLD if @style_bold.nil?
            @style_italic        = DEFAULT_STYLE_ITALIC if @style_italic.nil?
            @style_underline     = DEFAULT_STYLE_UNDERLINE if @style_underline.nil?
            @style_caps          = DEFAULT_STYLE_CAPS if @style_caps.nil?
            @style_align         ||= DEFAULT_STYLE_ALIGN
            @style_top           ||= DEFAULT_STYLE_TOP
            @style_bottom        ||= DEFAULT_STYLE_BOTTOM
            @style_line          ||= DEFAULT_STYLE_LINE
            @style_margin_top    ||= DEFAULT_STYLE_MARGIN_TOP
            @style_margin_right  ||= DEFAULT_STYLE_MARGIN_RIGHT
            @style_margin_bottom ||= DEFAULT_STYLE_MARGIN_BOTTOM
            @style_margin_left   ||= DEFAULT_STYLE_MARGIN_LEFT
          end
        end


        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #========== SETTERS ===============================

        # style types character, paragraph, and table are supported by word,
        # whence table_cell and table_row are emulated by Caracal.
        def type(value)
          allowed     = %w(character paragraph table table_row table_cell)
          given       = value.to_s.downcase.strip
          # @style_type = allowed.include?(given) ? given : DEFAULT_STYLE_TYPE
          raise "#{given}  is not in #{allowed}" unless allowed.include?(given)
          @style_type = given
        end


        #========== GETTERS ===============================

        def style_outline_lvl
          style_id.match(/Heading(\d)\Z/) {|match| match[1].to_i }
        end


        #========== STATE =================================

        def matches?(str)
          style_id.downcase == str.to_s.downcase
        end


        #========== VALIDATION ============================

        def valid?
          a = [:id, :name, :type]
          a.map {|m| send("style_#{m}") }.compact.size == a.size and (style_vertical_align.nil? or VERTICAL_ALIGNS.include? style_vertical_align)
        end

        def to_h
          option_keys.inject({}) do |h, k|
            v = self.send "style_#{k}"
            h[k] = v unless v.nil?
            h
          end
        end

        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [:type, :base, :bold, :italic, :underline, :caps, :top, :bottom, :size, :line, :id, :name, :color, :background, :font, :align, :widow_control, :keep_lines, :keep_next] +
              %w(left right first).map{|b| :"indent_#{b}" } +
              %w(top right bottom left).map{|b| :"margin_#{b}" } +
              %w(top right bottom left horizontal vertical).map{|b| %w(style size color).map{|a| :"border_#{b}_#{a}" } }.flatten
        end

      end

    end
  end
end
