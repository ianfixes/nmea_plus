lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nmea_plus/version"

Gem::Specification.new do |spec|
  spec.name          = "nmea_plus"
  spec.description   = <<-EODESCRIPTION
    A pure-ruby parser and decoder toolkit for NMEA messages (GPS, AIS, and other similar formats)
    that provides convenient access to all data fields. All standard NMEA messages,
    nearly all AIS messages, and some proprietary NMEA messages are supported.
  EODESCRIPTION
  spec.version       = NMEAPlus::VERSION
  spec.licenses      = ["Apache-2.0"]
  spec.authors       = ["Ian Katz"]
  spec.email         = ["ianfixes@gmail.com"]

  spec.summary       = "Parse and decode NMEA (GPS) and AIS messages"
  spec.homepage      = "http://github.com/ianfixes/nmea_plus"

  spec.files         = ["README.md", ".yardopts"] + Dir["lib/**/*.*"].reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    # "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org,
    # or delete to allow pushes to any server."
    # spec.metadata['allowed_push_host'] =
    spec.metadata["rubygems_mfa_required"] = "true"
  end

  spec.required_ruby_version = ">= 2.0"

  spec.add_dependency "racc", "~> 1.8"
end
