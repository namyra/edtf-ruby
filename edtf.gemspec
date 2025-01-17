# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'edtf/version'

Gem::Specification.new do |s|
  s.name        = 'edtf'
  s.version     = EDTF::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sylvester Keil']
  s.email       = ['http://sylvester.keil.or.at']
  s.homepage    = 'http://inukshuk.github.com/edtf-ruby'
  s.summary     = 'Extended Date/Time Format for Ruby.'
  s.description = 'An Extended Date/Time Format (EDTF) Parser for Ruby.'
  s.license     = 'FreeBSD'

  s.add_development_dependency('rake', ['~>0.9'])
  s.add_development_dependency('racc', ['~>1.4'])
  s.add_development_dependency('cucumber', ['~>1.0'])
  s.add_development_dependency('rspec', ['~>2.6'])
  s.add_development_dependency('ZenTest', ['~>4.6'])

  s.files        = `git ls-files`.split("\n") << 'lib/edtf/parser.rb'
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'

  s.rdoc_options      = %w{--line-numbers --inline-source --title "EDTF-Ruby" --main README.md --webcvs=http://github.com/inukshuk/edtf-ruby/tree/master/}
  s.extra_rdoc_files  = %w{README.md LICENSE}
  
end

# vim: syntax=ruby