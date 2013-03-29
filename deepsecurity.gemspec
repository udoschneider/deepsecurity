# -*- encoding: utf-8 -*-
require File.expand_path('../lib/deepsecurity/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Udo Schneider"]
  gem.email = ["Udo.Schneider@homeaddress.de"]
  gem.description = %q{Trend Micro DeepSecurity Wrapper}
  gem.summary = %q{Trend Micro DeepSecurity Wrapper}
  gem.homepage = ""

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = "deepsecurity"
  gem.require_paths = ["lib"]
  gem.version = DeepSecurity::VERSION

  gem.add_dependency "savon"
  gem.add_dependency "ruby-cache"

  gem.add_dependency "gli"
  gem.add_dependency 'progressbar'
  gem.add_dependency "json"

  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet'
  # gem.add_development_dependency 'github-markup'

end

