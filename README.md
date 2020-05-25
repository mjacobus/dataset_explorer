# DatasetExplorer

[![Build Status](https://travis-ci.org/mjacobus/dataset_explorer.svg?branch=master)](https://travis-ci.org/mjacobus/dataset_explorer)
[![Coverage Status](https://coveralls.io/repos/github/mjacobus/dataset_explorer/badge.svg?branch=master)](https://coveralls.io/github/mjacobus/dataset_explorer?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/ae41e3facbadaabaa463/maintainability)](https://codeclimate.com/github/mjacobus/dataset_explorer/maintainability)

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
  DatasetExplorer::Collector.instance.collect('type-of-request', result)
end

# somewhere

DatasetExplorer::Collector.explain('type-of-request')
# or
DatasetExplorer::Collector.explain_all
```

Example:

```ruby
require 'bundler/setup'
require 'open-uri'
require 'json'
require 'dataset_explorer'
require 'awesome_print'

urls = {
  github: 'https://pages.github.com/versions.json',
  github_repo_contents: 'https://api.github.com/repos/mjacobus/rubyjobsbrazil/contents',
}

COLLECTOR = DatasetExplorer::Collector.instance

urls.each do |provider, url|
  data = JSON.parse(open(url).read)
  COLLECTOR.collect(provider, data)
end

COLLECTOR.explain_all(format: :table).each do |type, explanation|
  puts type
  puts explanation
end
```

Explanation will be:

```
github
+------------------------------+--------------------------------------------------------------------------+
| jekyll                       | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-sass-converter        | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| kramdown                     | Possible types: [string], NULL, Min/max Length: 6/6                      |
| jekyll-commonmark-ghpages    | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| liquid                       | Possible types: [string], NULL, Min/max Length: 5/5                      |
| rouge                        | Possible types: [string], NULL, Min/max Length: 6/6                      |
| github-pages-health-check    | Possible types: [string], NULL, Min/max Length: 6/6                      |
| jekyll-redirect-from         | Possible types: [string], NULL, Min/max Length: 6/6                      |
| jekyll-sitemap               | Possible types: [string], NULL, Min/max Length: 5/5                      |
| jekyll-feed                  | Possible types: [string], NULL, Min/max Length: 6/6                      |
| jekyll-gist                  | Possible types: [string], NULL, Min/max Length: 5/5                      |
| jekyll-paginate              | Possible types: [string], NULL, Min/max Length: 5/5                      |
| jekyll-coffeescript          | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-seo-tag               | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-github-metadata       | Possible types: [string], NULL, Min/max Length: 6/6                      |
| jekyll-avatar                | Possible types: [string], NULL, Min/max Length: 5/5                      |
| jekyll-remote-theme          | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jemoji                       | Possible types: [date, time, string], NULL, Min/max Length: 6/6          |
| jekyll-mentions              | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-relative-links        | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-optional-front-matter | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-readme-index          | Possible types: [string], NULL, Min/max Length: 5/5                      |
| jekyll-default-layout        | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-titles-from-headings  | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-swiss                 | Possible types: [string], NULL, Min/max Length: 5/5                      |
| minima                       | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-primer          | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-architect       | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-cayman          | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-dinky           | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-hacker          | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-leap-day        | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-merlot          | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-midnight        | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-minimal         | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-modernist       | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-slate           | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-tactile         | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| jekyll-theme-time-machine    | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| ruby                         | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| github-pages                 | Possible types: [date, time, string, integer], NULL, Min/max Length: 3/3 |
| html-pipeline                | Possible types: [date, time, string], NULL, Min/max Length: 6/6          |
| sass                         | Possible types: [date, time, string], NULL, Min/max Length: 5/5          |
| safe_yaml                    | Possible types: [string], NULL, Min/max Length: 5/5                      |
| nokogiri                     | Possible types: [date, time, string], NULL, Min/max Length: 6/6          |
+------------------------------+--------------------------------------------------------------------------+
github_repo_contents
+-----------------+---------------------------------------------------------+
| [].name         | Possible types: [string], NULL, Min/max Length: 2/14    |
| [].path         | Possible types: [string], NULL, Min/max Length: 2/14    |
| [].sha          | Possible types: [string], NULL, Min/max Length: 40/40   |
| [].size         | Possible types: [integer], NULL                         |
| [].url          | Possible types: [string], NULL, Min/max Length: 75/87   |
| [].html_url     | Possible types: [string], NULL, Min/max Length: 57/69   |
| [].git_url      | Possible types: [string], NULL, Min/max Length: 103/103 |
| [].download_url | Possible types: [string], NULL, Min/max Length: 72/79   |
| [].type         | Possible types: [string], NULL, Min/max Length: 3/4     |
| []._links.self  | Possible types: [string], NULL, Min/max Length: 75/87   |
| []._links.git   | Possible types: [string], NULL, Min/max Length: 103/103 |
| []._links.html  | Possible types: [string], NULL, Min/max Length: 57/69   |
+-----------------+---------------------------------------------------------+
```

Or if you try like this

```ruby
data = {
  user: {
    first_name: 'John',
    last_name: 'Doe',
    achievements: [
      {
        headline: '10 nights with no sleep',
        tag: 'amazing'
      },
      {
        headline: 'read 2 books in 6 hours',
        tag: 'nerd'
      }
    ]
  }
}

DatasetExplorer::Collector.instance.collect(:achievements, data)
result = DatasetExplorer::Collector.instance.explain(:achievements).keys

# result is:

[
  "user.first_name",
  "user.last_name",
  "user.achievements.[].headline",
  "user.achievements.[].tag"
]
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
