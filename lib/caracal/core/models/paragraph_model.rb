require 'caracal/core/models/base_model'
require 'caracal/core/models/bookmark_model'
require 'caracal/core/models/link_model'
require 'caracal/core/models/text_model'
require 'caracal/errors'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # paragraph data.
      #
      class ParagraphModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # readers
        attr_reader :paragraph_style
        attr_reader :paragraph_align
        attr_reader :paragraph_color
        attr_reader :paragraph_size
        attr_reader :paragraph_bold
        attr_reader :paragraph_italic
        attr_reader :paragraph_underline
        attr_reader :paragraph_bgcolor
        attr_reader :paragraph_keep_next
        attr_reader :paragraph_tabs


        # initialization
        def initialize(options={}, &block)
          content = options.delete(:content) { '' }
          # TBD: maybe the block passed to #text is actually needed, but for now it seems
          # it only leads to double eval (one in wrong context)
          text content, options.dup #, &block
          @indent = nil
          super options, &block
        end


        #--------------------------------------------------
        # Public Instance Methods
        #--------------------------------------------------

        #========== GETTERS ===============================

        # .runs
        def runs
          @runs ||= []
        end

        # .run_attributes
        def run_attributes
          {
            color:      paragraph_color,
            size:       paragraph_size,
            bold:       paragraph_bold,
            italic:     paragraph_italic,
            underline:  paragraph_underline,
            bgcolor:    paragraph_bgcolor
          }
        end

        # .plaintext
        def plain_text
          runs.collect { |run| run.try(:text_content).to_s }.join(' ').strip
        end

        #========== SETTERS ===============================

        # booleans
        [:bold, :italic, :keep_next, :underline].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set "@paragraph_#{ m }", !!value
          end
        end

        # integers
        [:size].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set "@paragraph_#{ m }", value.to_i
          end
        end

        # strings
        [:bgcolor, :color, :style].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set "@paragraph_#{ m }", value.to_s
          end
        end

        # symbols
        [:align].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set "@paragraph_#{ m }", value.to_s.to_sym
          end
        end

        # Getter/setter
        def indent(hash = nil)
          return @indent if hash.nil?

          unless [:left, :right].include?(hash.keys.first) && hash.values.first.is_a?(Integer)
            raise Caracal::Errors::InvalidModelError, 'the indent setter requires a hash like left: X or right: Y.'
          end

          @indent = { side: hash.keys.first, value: hash.values.first }
        end

        def tabs(values)
          @paragraph_tabs = values
        end

        #========== SUB-METHODS ===========================

        def field(*args, &block)
          options = Caracal::Utilities.extract_options! args
          options.merge! name: args.first if args.first

          model = Caracal::Core::Models::FieldModel.new options, &block
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidModelError, ':field method must receive a string for the field name.'
          end
          model
        end

        # .bookmarks
        def bookmark_start(*args, &block)
          options = Caracal::Utilities.extract_options! args
          options.merge! start: true

          model = Caracal::Core::Models::BookmarkModel.new options, &block
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidModelError, 'Bookmark starting tags require an id and a name.'
          end
          model
        end
        def bookmark_end(*args, &block)
          options = Caracal::Utilities.extract_options! args
          options.merge! start: false

          model = Caracal::Core::Models::BookmarkModel.new options, &block
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidModelError, 'Bookmark ending tags require an id.'
          end
          model
        end

        # .br
        def br
          model = Caracal::Core::Models::LineBreakModel.new
          runs << model
          model
        end

        # .link
        def link(*args, &block)
          options = Caracal::Utilities.extract_options!(args)
          options.merge! content: args[0] if args[0]
          options.merge! href:    args[1] if args[1]

          model = Caracal::Core::Models::LinkModel.new(options, &block)
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidModelError, ':link method must receive strings for the display text and the external href.'
          end
          model
        end

        # .page
        def page
          model = Caracal::Core::Models::PageBreakModel.new wrap: false
          runs << model
          model
        end

        # .text
        def text(*args, &block)
          options = Caracal::Utilities.extract_options!(args)
          options.merge! content: args.first if args.first

          model = Caracal::Core::Models::TextModel.new(options, &block)
          if model.valid?
            runs << model
          else
            raise Caracal::Errors::InvalidModelError, ':text method must receive a string for the display text.'
          end
          model
        end

        #========== STATE =================================

        def empty?
          runs.size.zero? || plain_text.length.zero?
        end

        #========== VALIDATION ============================

        def valid?
          runs.size > 0
        end


        #--------------------------------------------------
        # Private Instance Methods
        #--------------------------------------------------
        private

        def option_keys
          [:content, :style, :align, :color, :size, :bold, :italic, :underline, :bgcolor, :tabs]
        end

      end

    end
  end
end
