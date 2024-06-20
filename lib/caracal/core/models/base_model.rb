# frozen_string_literal: true

module Caracal
  module Core
    module Models
      # This class encapsulates the logic needed for functions that
      # do not store or manipulate data.
      class BaseModel
        attr_reader :alignment, :errors # FIXME: move to models that actually need this

        # initialization
        def initialize(options = {}, &block)
          @errors = []
          @alignment = options.key?(:align) && StyleModel::HORIZONTAL_ALIGNS.include?(options[:align]) ? options[:align] : nil

          options.each do |(key, value)|
            # send(key, value) if option_keys.include?(key) # safer, but need to define complete border model accessors first.
            raise "trying to set #{key.inspect} which is not known to #{inspect}" unless respond_to? key

            send key, value
          end

          return unless block_given?

          block.arity < 1 ? instance_eval(&block) : block[self]
        end

        #=============== VALIDATION ===========================

        def valid?
          true
        end

        def get_model(name)
          instance_variable_get "@#{self.class.attr_prefix}_#{name}"
        end

        private

        def option_keys
          []
        end

        def validate_all(attr, allow_nil: false)
          array = send attr
          if array.nil? && allow_nil
            true
          elsif array.all? :valid?
            true
          else
            @errors << { message: array.reject do |a|
                                    a.errors.nil? or a.errors.empty?
                                  end.map(&:errors), model: self, attribute: attr }
            false
          end
        end

        def validate_size(attr, at_least: 0, allow_nil: false)
          value = send "#{self.class.attr_prefix}_#{attr}"
          if value.nil? && allow_nil
            true
          elsif !value.nil? && (value > at_least)
            true
          else
            @errors << { message: "#{attr} must be greater than #{at_least}", model: self, attribute: attr,
                         value: value }
            false
          end
        end

        def validate_presence(attr, allow_empty: false)
          value = send "#{self.class.attr_prefix}_#{attr}"

          value_empty = value.respond_to?(:empty?) ? value.empty? : false

          if !value.nil? && ((value_empty && allow_empty) || !value_empty)
            true
          else
            @errors << { message: "#{attr} must not be empty", model: self, attribute: attr, value: value }
            false
          end
        end

        def validate_inclusion(attr, within: [], allow_nil: true)
          value = send "#{self.class.attr_prefix}_#{attr}"
          if (allow_nil && value.nil?) || within.include?(value)
            true
          else
            @errors << { message: "#{value.inspect} is not in #{within.inspect}", model: self, attribute: attr,
                         value: value }
            false
          end
        end

        def validate(msg)
          if yield
            true
          else
            @errors << { message: msg, model: self }
            false
          end
        end

        def self.use_prefix(str)
          define_singleton_method :attr_prefix do
            str.to_s
          end
        end

        def self.define_reader_and_default(name, default: nil)
          const_set :"DEFAULT_#{attr_prefix.upcase}_#{name.to_s.upcase}", default
          attr_reader "#{attr_prefix}_#{name}"
        end

        def self.has_integer_attribute(name, default: nil)
          define_reader_and_default name, default: default

          prefix = attr_prefix
          define_method name do |value|
            v = value&.to_i
            instance_variable_set "@#{prefix}_#{name}", v
          end
        end

        def self.has_symbol_attribute(name, default: nil, downcase: false)
          define_reader_and_default name, default: default
          prefix = attr_prefix

          define_method name do |value|
            if value.nil?
              instance_variable_set "@#{prefix}_#{name}", nil
            else
              v = value.to_s
              v = v.downcase if downcase
              instance_variable_set "@#{prefix}_#{name}", v.to_sym
            end
          end
        end

        def self.has_string_attribute(name, default: nil)
          define_reader_and_default name, default: default

          prefix = attr_prefix
          define_method name do |value|
            v = value&.to_s
            instance_variable_set "@#{prefix}_#{name}", v
          end
        end

        def self.has_boolean_attribute(name, default: nil)
          define_reader_and_default name, default: default

          prefix = attr_prefix
          define_method name do |value|
            v = case value
                when nil, 'nil', 'none'
                  nil
                when 'false', false, 0, '0'
                  false
                else
                  true
                end

            instance_variable_set "@#{prefix}_#{name}", v
          end
        end

        def self.has_model_attribute(name, model: nil, default: nil)
          define_reader_and_default name, default: default

          prefix = attr_prefix
          define_method name do |options = {}, &block|
            case options
            when model
              options.instance_eval(&block) if block_given?
              v = options
            when nil
              v = nil
            else
              v = model.new(options, &block)
            end
            raise Caracal::Errors::InvalidModelError, v.errors.inspect unless v.valid?

            instance_variable_set "@#{prefix}_#{name}", v
          end
        end
      end
    end
  end
end
