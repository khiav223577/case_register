# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_template/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem_template'
  spec.version       = GemTemplate::VERSION # gem_template
  spec.authors       = ['khiav reoy']
  spec.email         = ['mrtmrt15xn@yahoo.com.tw']

  spec.summary       = 'Provides cross-rails methods for you to upgrade rails, backport features, create easy-to-maintain gems, and so on.'
  spec.description   = 'Provides cross-rails methods for you to upgrade rails, backport features, create easy-to-maintain gems, and so on.'
  spec.homepage      = 'https://github.com/khiav223577/gem_template'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject{|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}){|f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata      = {
    'homepage_uri'      => 'https://github.com/khiav223577/gem_template',
    'changelog_uri'     => 'https://github.com/khiav223577/gem_template/blob/master/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/khiav223577/gem_template',
    'documentation_uri' => 'https://www.rubydoc.info/gems/gem_template',
    'bug_tracker_uri'   => 'https://github.com/khiav223577/gem_template/issues',
  }

  spec.add_development_dependency 'bundler', '>= 1.17', '< 3.x'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'backports', '~> 3.15.0'

  spec.add_dependency 'activerecord', '>= 3'
end
