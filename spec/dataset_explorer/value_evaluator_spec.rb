# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DatasetExplorer::ValueEvaluator do
  let(:evaluator) { described_class.new('the-name') }

  it 'evaluates boolean' do
    evaluator.evaluate('false')
    evaluator.evaluate('true')
    evaluator.evaluate('True')
    evaluator.evaluate('FALSE')
    evaluator.evaluate(true)
    evaluator.evaluate(false)
    evaluator.evaluate(nil)

    expect(evaluator.types).to eq(['boolean'])
  end

  it 'evaluates string' do
    evaluator.evaluate('false')
    evaluator.evaluate('super true')

    expect(evaluator.types).to eq(['string'])
  end

  it 'evaluates float' do
    evaluator.evaluate('-1.23')
    evaluator.evaluate(1.23)

    expect(evaluator.types).to eq(['float'])
  end

  it 'evaluates integer' do
    evaluator.evaluate('1')
    evaluator.evaluate(12_344)
    evaluator.evaluate('-1')

    expect(evaluator.types).to eq(['integer'])
  end

  it 'evaluates date' do
    evaluator.evaluate('2001-02-03')
    evaluator.evaluate(Date.today)

    expect(evaluator.types).to eq(['date'])
  end

  it 'evaluates time' do
    evaluator.evaluate(Time.now.to_s)
    evaluator.evaluate(Time.now)

    expect(evaluator.types).to eq(['time'])
  end

  it 'records the max and min length' do
    evaluator.evaluate('1234')
    evaluator.evaluate('12')
    evaluator.evaluate(true)
    evaluator.evaluate(false)
    evaluator.evaluate(nil)

    expect(evaluator.max_length).to eq(4)
    expect(evaluator.min_length).to eq(2)
  end
end
