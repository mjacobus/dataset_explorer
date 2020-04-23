# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DatasetExplorer::Collector do
  let(:instance) { described_class.instance }

  before do
    instance.collect('users', name: :foo)
    instance.collect('users', last_name: :bar)
    instance.collect('posts', title: 'sup')
    instance.collect('posts', published_at: 'sup')
  end

  it 'collects data' do
    explanations = instance.explain_all

    expect(explanations).to eq(
      'users' => %w[name last_name],
      'posts' => %w[title published_at]
    )
  end
end
