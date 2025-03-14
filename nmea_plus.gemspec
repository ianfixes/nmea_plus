# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nmea_plus/version'

Gem::Specification.new do |spec|
  spec.name          = "nmea_plus"
  spec.description   = %q{A pure-ruby parser and decoder toolkit for NMEA messages (GPS, AIS, and other similar formats)
                          that provides convenient access to all data fields.  All standard NMEA messages,
                          nearly all AIS messages, and some proprietary NMEA messages are supported.
                         }
  spec.version       = NMEAPlus::VERSION
  spec.licenses      = ['Apache-2.0']
  spec.authors       = ["Ian Katz"]
  spec.email         = ["ianfixes@gmail.com"]

  spec.summary       = %q{Parse and decode NMEA (GPS) and AIS messages}
  spec.homepage      = "http://github.com/ianfixes/nmea_plus"

  spec.files         =  ['README.md', '.yardopts'] + Dir['lib/**/*.*'].reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency 'racc', '~> 1.8'

  spec.add_development_dependency 'bundler', '~> 2.5.21'
  spec.add_development_dependency 'rake',    '~> 13.2.1'
  spec.add_development_dependency 'rubocop', '~> 1.71.2'
  spec.add_development_dependency 'rspec',   '~> 3.13'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'simplecov-json', '~> 0.2.3'
  spec.add_development_dependency 'rexical', '~> 1.0'
  spec.add_development_dependency 'yard',    '~> 0.9.37'
end
