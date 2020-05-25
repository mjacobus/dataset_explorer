# frozen_string_literal: true

module DatasetExplorer
  class Collector
    def self.instance
      @instance ||= new
    end

    def initialize
      @collectors = {}
    end

    def collect(type, item)
      collector_for(type).add(item)
    end

    def explain_all(format: :hash)
      @collectors.keys.map do |key|
        [key, explain(key, format: format)]
      end.to_h
    end

    def explain(type, format: :hash)
      explanation = @collectors.fetch(type).explain

      if format == :table
        explanation = to_table(explanation)
      end

      explanation
    end

    private

    def collector_for(type)
      @collectors[type] ||= ItemCollector.new
    end

    def to_table(fields)
      rows = []
      fields.each do |key, description|
        rows << [key, description]
      end
      Terminal::Table.new(rows: rows)
    end

    private_class_method :new
  end
end
