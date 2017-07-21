# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mrmanga/version'

Gem::Specification.new do |spec|
  spec.name          = 'mrmanga'
  spec.version       = Mrmanga::VERSION
  spec.authors       = ['Andrey Viktorov']
  spec.email         = ['andv@outlook.com']

  spec.summary       = 'Downloader for mintmanga/readmanga'
  spec.homepage      = 'https://github.com/4ndv/mrmanga'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'highline', '~> 1.7'
  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'faraday', '~> 0.12'
  spec.add_dependency 'prawn', '~> 2.2'
  spec.add_dependency 'down', '~> 4.0'
  spec.add_dependency 'parallel', '~> 1.11'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
end
