# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tkh_events/version'

Gem::Specification.new do |spec|
  spec.name          = "tkh_events"
  spec.version       = TkhEvents::VERSION
  spec.authors       = ["Swami Atma"]
  spec.email         = ["swami@TenThousandHours.eu"]
  spec.summary       = %q{ Rails engine module for events such as workshops etc. }
  spec.description   = %q{ Rails engine module for events such as workshops etc. }
  spec.homepage      = "https://github.com/allesklar/tkh_events"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"

  spec.add_dependency 'tkh_search'
  spec.add_dependency 'tkh_toolbox'
  spec.add_dependency 'tkh_illustrations' # for the Image Uploader
  spec.add_dependency 'prawn' # for pdf generation of event attendance printout
  spec.add_dependency 'prawn-table'
end
