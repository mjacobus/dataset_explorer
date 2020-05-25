# frozen_string_literal: true

module DatasetExplorer
  class ItemCollector
    def initialize
      @keys = []
      @evaluators = {}
    end

    attr_reader :keys

    def add(item)
      unless item.is_a?(Array)
        return add_item(item)
      end

      item.each do |i|
        add_item(i, '[]')
      end
    end

    private

    def add_item(item, prefix = nil)
      new_values = item.keys.map do |key|
        map_keys(item[key], key, prefix)
      end.flatten.map(&:to_s).uniq

      @keys << new_values
      @keys = @keys.flatten.uniq
    end

    # rubocop:disable Metrics/MethodLength
    def map_keys(value, key = nil, prefix = nil)
      prefix = [prefix, key].compact.join('.')

      unless mappable?(value)
        evaluator_for(key).evaluate(value)
        return prefix
      end

      if behaves_like_hash?(value)
        return value.keys.map do |sub_key|
          map_keys(value[sub_key], sub_key, prefix)
        end
      end

      if value.respond_to?(:each)
        prefix = "#{prefix}.[]"
        return [].tap do |keys|
          value.each do |item_value|
            keys << map_keys(item_value, nil, prefix)
          end
        end
      end

      raise Error, 'Unforseen scenario'
    end
    # rubocop:enable Metrics/MethodLength

    def mappable?(value)
      if behaves_like_hash?(value)
        return true
      end

      if behaves_like_array?(value)
        return true
      end

      false
    end

    def behaves_like_hash?(value)
      value.respond_to?(:keys)
    end

    def behaves_like_array?(value)
      value.respond_to?(:each)
    end

    def evaluator_for(field)
      @evaluators[field] ||= ValueEvaluator.new(field)
    end
  end
end
