source "https://rubygems.org"

gemspec

group :development do
  gem "bundler", "~> 2.2"
  gem "rake", "~> 13.2.1"
  gem "rexical", "~> 1.0"
  gem "simplecov", "~> 0.22"
  gem "simplecov-json", "~> 0.2.3"
  gem "yard", "~> 0.9.37"

  if RUBY_VERSION >= "2.7"
    gem "rubocop", "~> 1.72.1"
    gem "rubocop-performance", "~> 1.20"
    gem "rubocop-rake", "~> 0.7.1"
    gem "rubocop-rspec", "~> 2.27"
    gem "rubocop-thread_safety", "~> 0.7.2"
  end

  # rubocop:disable Style/IfUnlessModifier -- stay consistent, just in case we add more gems
  if RUBY_VERSION >= "3.0"
    gem "rubocop-yard", "~> 0.1"
  end
  # rubocop:enable Style/IfUnlessModifier
end
