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

    def explain_all
      @collectors.keys.map do |key|
        [key, explain(key)]
      end.to_h
    end

    def explain(type)
      @collectors.fetch(type).values
    end

    private

    def collector_for(type)
      @collectors[type] ||= ItemCollector.new
    end

    private_class_method :new
  end
end
