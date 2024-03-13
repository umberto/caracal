module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed for functions that
      # do not store or manipulate data.
      class BaseModel
        def self.use_prefix(str)
          define_singleton_method :attr_prefix do
            str.to_s
          end
        end

        def self.has_attribute(name, default: nil)
          const_set :"DEFAULT_#{attr_prefix.upcase}_#{name.to_s.upcase}", default
          attr_reader "#{attr_prefix}_#{name}"

          define_method name do |value|
            instance_variable_set "@#{self.class.attr_prefix}_#{name}", value.to_i
          end
        end

        def self.has_integer_attribute(name, default: nil)
          has_attribute name, default: default

          define_method name do |value|
            instance_variable_set "@#{self.class.attr_prefix}_#{name}", value.to_i
          end
        end

        def self.has_symbol_attribute(name, default: nil)
          has_attribute name, default: default

          define_method name do |value|
            instance_variable_set "@#{self.class.attr_prefix}_#{name}", value.to_s.to_sym
          end
        end

        def self.has_string_attribute(name, default: nil)
          has_attribute name, default: default

          define_method name do |value|
            instance_variable_set "@#{self.class.attr_prefix}_#{name}", value.to_s
          end
        end

        def self.has_boolean_attribute(name, default: nil)
          has_attribute name, default: default

          define_method name do |value|
            case value
            when nil, 'nil', 'none'
              v = nil
            when 'true', true, 1, '1'
              v = true
            else
              v = false
            end

            instance_variable_set "@#{self.class.attr_prefix}_#{name}", v
          end
        end

        def self.has_model_attribute(name, model: nil, default: nil)
          has_attribute name, default: default

          define_method name do |options, &block|
            instance_variable_set "@#{self.class.attr_prefix}_#{name}", model.new(options, &block)
          end
        end


        attr_reader :alignment

        # initialization
        def initialize(options={}, &block)
          @alignment = options.key?(:align) && [:left, :center, :right, :both].include?(options[:align]) ? options[:align] : nil
          options.each do |(key, value)|
            send(key, value) if option_keys.include?(key)
          end

          if block_given?
            (block.arity < 1) ? instance_eval(&block) : block[self]
          end
        end

        #=============== VALIDATION ===========================

        def valid?
          true
        end

        private

        def option_keys
          []
        end

      end

    end
  end
end
