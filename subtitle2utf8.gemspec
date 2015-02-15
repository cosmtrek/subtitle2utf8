# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subtitle2utf8/version'

Gem::Specification.new do |spec|
  spec.name          = 'subtitle2utf8'
  spec.version       = Subtitle2utf8::VERSION
  spec.authors       = ['Rick Yu']
  spec.email         = ['cosmtrek@gmail.com']
  spec.summary       = %q{Convert movie subtitle's encoding to utf-8.}
  spec.description   = %q{This simple gem is used to convert movie subtitle's encoding to utf-8.}
  spec.homepage      = 'https://github.com/cosmtrek/subtitle2utf8'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'rchardet', '~> 1.6.0'
end
