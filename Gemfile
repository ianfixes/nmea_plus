source "https://rubygems.org"

gemspec

group :development do
  gem "bundler", "~> 2.2"
  gem "rake", "~> 13.2.1"
  gem "rexical", "~> 1.0"
  gem "rspec", "~> 3.0"
  gem "simplecov", "~> 0.10", ">= 0.10.0"
  gem "simplecov-json", "~> 0.2", ">= 0.2.0"
  gem "yard", "~> 0.9.37"

  # rubocop:disable Style/IfUnlessModifier -- stay consistent, just in case we add more gems
  if RUBY_VERSION >= "2.7"
    gem "rubocop", "~> 1.72.1"
  end

  if RUBY_VERSION >= "3.0"
    gem "rubocop-yard", "~> 0.1"
  end
  # rubocop:enable Style/IfUnlessModifier
end
