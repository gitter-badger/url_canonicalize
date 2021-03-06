# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'url_canonicalize/version'

Gem::Specification.new do |s|
  s.name          = 'url_canonicalize'
  s.version       = URLCanonicalize::VERSION
  s.authors       = ['Dominic Sayers']
  s.email         = ['developers@xenapto.com']
  s.summary       = 'Finds the canonical version of a URL'
  s.description   = 'Rubygem that finds the canonical version of a URL by '\
                    'providing #canonicalize methods for the String, URI::HTTP'\
                    ', URI::HTTPS and Addressable::URI classes'
  s.homepage      = 'https://github.com/Xenapto/url_canonicalize'
  s.license       = 'MIT'

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ /^spec\//
  end

  s.test_files = []
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'addressable', '~> 2' # To normalize URLs
  s.add_dependency 'nokogiri', '~> 1' # To look for <link rel="canonical" ...> in HTML
end
