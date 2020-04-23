# frozen_string_literal: true

module DatasetExplorer
  class ItemCollector
    def initialize
      @values = []
    end

    attr_reader :values

    def add(item)
      new_values = item.keys.map do |key|
        map_keys(item[key], key)
      end.flatten.map(&:to_s).uniq

      @values << new_values
      @values = @values.flatten.uniq
    end

    private

    # rubocop:disable Metrics/MethodLength
    def map_keys(value, key = nil, prefix = nil)
      prefix = [prefix, key].compact.join('.')

      unless mappable?(value)
        return prefix
      end

      if behaves_like_hash?(value)
        return value.keys.map do |sub_key|
          map_keys(value[sub_key], sub_key, prefix)
        end
      end

      if value.respond_to?(:each)
        prefix = "#{prefix}.[]"
        return [].tap do |values|
          value.each do |item_value|
            values << map_keys(item_value, nil, prefix)
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
  end
end
