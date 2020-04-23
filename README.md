# DatasetExplorer

Explores a data set and keep track of all the fields ever returned.

The idea is to collect all the fields from a dataset, including the ones nested from an API that will omit some fields when they are `null`, or even to make sure that the fields listed in the documentation (or not listed at all) can be explained by the output.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dataset_explorer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dataset_explorer

## Usage

```ruby
def some_method_that_pulls_data(args)
  response = client.get('url', args)
  DatasetExplorer.log('type-of-request', result)
end

# somewhere

p DatasetExplorer.explain('type-of-request')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mjacobus/dataset_explorer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mjacobus/dataset_explorer/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DatasetExplorer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mjacobus/dataset_explorer/blob/master/CODE_OF_CONDUCT.md).
