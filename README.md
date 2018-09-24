# MoneyExchange

Money gem integration with Open Exchange Rates API.

Development goals:

* seamless integration with `money` gem
* flexible caching
* Open Exchange Rates API quota protection

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'money-exchange'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install money-exchange

## Usage

Create and configure `MoneyExchange::Bank` and set it as `Money.default_bank`.

```ruby
require 'money_exchange'

bank = MoneyExchange::Bank.new(
  client: MoneyExchange::Client::OXR.new(ENV['OXR_APP_ID']),
  ttl: 24 * 60 * 60
)

Money.default_bank = bank
```

It will make `Money` use it transparently for currency conversion.

```ruby
Money.new(10000, 'USD').exchange_to('EUR')
# => #<Money fractional:85 currency:EUR>
```

### Caching

Exchange rates are cached internally on the rates store level for the number of seconds set with `ttl` option (defaults to 24 hours). If you want to use external cache store, e.g. the same as used in your Rails application, provide it as `cache_store` option.

```ruby
MoneyExchange::Bank.new(
  cache_store: Rails.cache,
  ttl: 12 * 60 * 60
)
```

### Open Exchange Rates API limits

OXR imposes usage limits in their API. In order to protect your quota, don't use the actual API in `development` or `test` environments. Instead configure the bank to use the local client preloaded with locally cached (sample) data.

Just save a response from https://openexchangerates.org/api/latest.json?app_id=OXR_APP_ID locally and load it when configuring the bank.

```ruby
data = JSON.parse(File.read("path/to/oxr-response.json"))

MoneyExchange::Bank.new(
  client: MoneyExchange::Client::Local.new(data)
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/szajbus/money-exchange. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MoneyExchange project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/money-exchange/blob/master/CODE_OF_CONDUCT.md).
