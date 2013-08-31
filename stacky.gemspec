# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'stacky'
  spec.version       = IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.1.0'
  spec.authors       = ['Gareth Davis']
  spec.email         = ['gareth.davis@mac.com']
  spec.description   = %q{Tool and library for working with jstack}
  spec.summary       = %q{Tool and library for working with jstack}
  spec.homepage      = 'http://stacky.github.io/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_dependency 'thor'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
