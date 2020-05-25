# frozen_string_literal: true

require 'date'
require 'time'
require 'terminal-table'

module DatasetExplorer
  class ValueEvaluator
    attr_reader :min_length
    attr_reader :max_length

    def initialize(field_name)
      @field_name = field_name
      @null = true
      @evaluators = {
        'date' => DateEvaluator.new,
        'time' => TimeEvaluator.new,
        'string' => StringEvaluator.new,
        'float' => FloatEvaluator.new,
        'integer' => IntegerEvaluator.new,
        'boolean' => BooleanEvaluator.new
      }
      @min_length = nil
      @max_length = nil
    end

    def evaluate(value)
      if value.nil?
        @null = true
        return
      end

      evaluate_length(value)

      @evaluators.each do |key, evaluator|
        unless evaluator.accept?(value)
          @evaluators.delete(key)
        end
      end
    end

    def types
      @evaluators.keys
    end

    def describe
      parts = ["Possible types: [#{types.join(', ')}]"]
      if @null
        parts << 'NULL'
      end

      if min_length
        parts << "Min/max Length: #{min_length}/#{max_length}"
      end

      parts.join(', ')
    end

    def evaluate_length(value)
      unless value.respond_to?(:length)
        return
      end

      length = value.length
      @min_length ||= length
      @max_length ||= length

      if @min_length > length
        @min_length = length
      end

      if @max_length < length
        @max_length = length
      end
    end

    class TimeEvaluator
      def accept?(value)
        if value.is_a?(String)
          return Time.parse(value.to_s)
        end

        value.is_a?(Time)
      rescue ArgumentError
        false
      end
    end

    class DateEvaluator
      def accept?(value)
        if value.is_a?(String)
          return Date.parse(value.to_s)
        end

        value.is_a?(Date)
      rescue ArgumentError
        false
      end
    end

    class StringEvaluator
      def accept?(value)
        value.is_a?(String)
      end
    end

    class FloatEvaluator
      def accept?(value)
        Float(value).to_s == value.to_s
      rescue ArgumentError, TypeError
        false
      end
    end

    class IntegerEvaluator
      def accept?(value)
        Integer(value)
      rescue ArgumentError, TypeError
        false
      end
    end

    class BooleanEvaluator
      ACCEPT = %w[
        true
        false
      ].freeze

      def accept?(value)
        ACCEPT.include?(value.to_s.downcase)
      end
    end
  end
end
