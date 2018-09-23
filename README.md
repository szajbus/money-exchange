# MoneyExchange

Money gem integration with Open Exchange Rates API.

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

Example setup with Ruby on Rails.

Create and configure `MoneyExchange::Bank` and connect it to `Money`.

```ruby
require 'money_exchange'

bank = MoneyExchange::Bank.new(
  client: MoneyExchange::Client::OXR.new(ENV['OXR_APP_ID']),
  cache_store: Rails.cache,
  ttl: 12.hours
)

Money.default_bank = bank
```

It will make `Money` use it transparently for currency conversion.

```ruby
Money.new(10000, 'USD').exchange_to('EUR').format
# => "€85,14"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/szajbus/money-exchange. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Money::Exchange project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/money-exchange/blob/master/CODE_OF_CONDUCT.md).
