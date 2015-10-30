# coding: utf-8
lib = File.expand_path('../gem/lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nmea_plus/version'

Gem::Specification.new do |spec|
  spec.name          = "nmea_plus"
  spec.description   = "A ruby-based NMEA (plus similar formats) message parser"
  spec.version       = NMEAPlus::VERSION
  spec.licenses      = ['Apache 2.0']
  spec.authors       = ["Ian Katz"]
  spec.email         = ["ifreecarve@gmail.com"]

  spec.summary       = %q{Tools for NMEA-style messages}
  spec.homepage      = "http://github.com/ifreecarve/nmea_plus"

  spec.files         =  Dir['gem/**/*.*'].reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["gem/lib"]

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency 'racc', '~>1.4', '>= 1.0'

  spec.add_development_dependency 'bundler', '~> 1.3', '>= 1.3.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.31', '>= 0.31.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'
  spec.add_development_dependency 'simplecov-json', '~> 0.2', '>= 0.2.0'
  spec.add_development_dependency 'rexical', '~>1.0', '>= 1.0'
end
