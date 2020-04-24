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
  data = [JSON.parse(open(url).read)].flatten

  data.each do |item|
    COLLECTOR.collect(provider, item)
  end
end

explanation = COLLECTOR.explain_all
```

Explanation will be:

```ruby
{
  github: [
    "jekyll",
    "jekyll-sass-converter",
    "kramdown",
    "jekyll-commonmark-ghpages",
    "liquid",
    "rouge",
    "github-pages-health-check",
    "jekyll-redirect-from",
    "jekyll-sitemap",
    "jekyll-feed",
    "jekyll-gist",
    "jekyll-paginate",
    "jekyll-coffeescript",
    "jekyll-seo-tag",
    "jekyll-github-metadata",
    "jekyll-avatar",
    "jekyll-remote-theme",
    "jemoji",
    "jekyll-mentions",
    "jekyll-relative-links",
    "jekyll-optional-front-matter",
    "jekyll-readme-index",
    "jekyll-default-layout",
    "jekyll-titles-from-headings",
    "jekyll-swiss",
    "minima",
    "jekyll-theme-primer",
    "jekyll-theme-architect",
    "jekyll-theme-cayman",
    "jekyll-theme-dinky",
    "jekyll-theme-hacker",
    "jekyll-theme-leap-day",
    "jekyll-theme-merlot",
    "jekyll-theme-midnight",
    "jekyll-theme-minimal",
    "jekyll-theme-modernist",
    "jekyll-theme-slate",
    "jekyll-theme-tactile",
    "jekyll-theme-time-machine",
    "ruby",
    "github-pages",
    "html-pipeline",
    "sass",
    "safe_yaml",
    "nokogiri",
  ],
  github_repo: [
    "name",
    "path",
    "sha",
    "size",
    "url",
    "html_url",
    "git_url",
    "download_url",
    "type",
    "_links.self",
    "_links.git",
    "_links.html"
  ]
}
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
result = DatasetExplorer::Collector.explain_all(:achievements)

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
