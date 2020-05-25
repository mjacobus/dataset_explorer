# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DatasetExplorer::Collector do
  let(:instance) { described_class.instance }

  before do
    instance.collect('users', name: 'foo')
    instance.collect('users', last_name: 'bar')
    instance.collect('posts', title: 'sup')
    instance.collect('posts', published_at: 'sup')
  end

  # rubocop:disable RSpec/ExampleLength
  it 'collects data' do
    explanations = instance.explain_all(format: :hash)

    expect(explanations).to eq(
      'users' => {
        'last_name' => 'Possible types: [string], NULL, Min/max Length: 3/3',
        'name' => 'Possible types: [string], NULL, Min/max Length: 3/3'
      },
      'posts' => {
        'published_at' => 'Possible types: [string], NULL, Min/max Length: 3/3',
        'title' => 'Possible types: [string], NULL, Min/max Length: 3/3'
      }
    )
  end

  it 'explains as a table' do
    table = instance.explain_all(format: :table)['users'].to_s

    expected = <<~STR
      +-----------+-----------------------------------------------------+
      | name      | Possible types: [string], NULL, Min/max Length: 3/3 |
      | last_name | Possible types: [string], NULL, Min/max Length: 3/3 |
      +-----------+-----------------------------------------------------+
    STR

    expect(table.strip).to eq(expected.strip)
  end
  # rubocop:enable RSpec/ExampleLength
end
