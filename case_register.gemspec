# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'case_register/version'

Gem::Specification.new do |spec|
  spec.name          = 'case_register'
  spec.version       = CaseRegister::VERSION
  spec.authors       = ['khiav reoy']
  spec.email         = ['khiav223577@gmail.com']

  spec.summary       = 'Provide a design pattern to manage switch statements by mapping each case to a method which is dynamically defined in advance.'
  spec.description   = 'Provide a design pattern to manage switch statements by mapping each case to a method which is dynamically defined in advance.'
  spec.homepage      = 'https://github.com/khiav223577/case_register'
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
    'homepage_uri'      => 'https://github.com/khiav223577/case_register',
    'changelog_uri'     => 'https://github.com/khiav223577/case_register/blob/master/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/khiav223577/case_register',
    'documentation_uri' => 'https://www.rubydoc.info/gems/case_register',
    'bug_tracker_uri'   => 'https://github.com/khiav223577/case_register/issues',
  }

  spec.add_development_dependency 'bundler', '>= 1.17', '< 3.x'
  spec.add_development_dependency 'rake', '>= 10.5.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
