# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DatasetExplorer::ItemCollector do
  let(:entry) { described_class.new }

  it 'merges objects' do
    entry.add(foo: :bar)
    entry.add(foo: :bar, baz: :xyz)

    expected = %w[
      foo
      baz
    ]

    expect(entry.values).to eq(expected)
  end

  context 'with nested objected' do
    before do
      entry.add(username: :foo)
      entry.add(languages: [{ name: 'ruby', experience: 'lots' }])
      entry.add(languages: [{ experience: 'lots' }])
      entry.add(username: :foo, status: { message: 'ok' })
    end

    it 'properly formatts them' do
      expected = [
        'username',
        'languages.[].name',
        'languages.[].experience',
        'status.message'
      ]

      expect(entry.values).to eq(expected)
    end
  end
end
