lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "money_exchange/version"

Gem::Specification.new do |spec|
  spec.name          = "money-exchange"
  spec.version       = MoneyExchange::VERSION
  spec.authors       = ["Michał Szajbe"]
  spec.email         = ["michal.szajbe@gmail.com"]

  spec.summary       = %q{Money gem integration with Open Exchange Rates API}
  spec.description   = %q{This gem provides money-gem-compatible rates store connected to Open Exchange Rates API.}
  spec.homepage      = "https://github.com/szajbus/money-exchange"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "money", "~> 6.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop", "~> 0.9.1"
end
