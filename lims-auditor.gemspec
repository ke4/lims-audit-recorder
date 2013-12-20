# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lims-auditor-app/version"

Gem::Specification.new do |s|
  s.name        = "lims-auditor-app"
  s.version     = Lims::AuditorApp::VERSION
  s.authors     = ["Karoly Erdos"]
  s.email       = ["ke4@sanger.ac.uk"]
  s.homepage    = "http://sanger.ac.uk/"
  s.summary     = %q{This application listens to the message queue and record everything that happens in S2 so that it can be replayed if necessary}
  s.description = %q{Provides utility function for the new LIMS to log messages to a file.}

  s.rubyforge_project = "lims-auditor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "config"]

  s.add_dependency('virtus')
  s.add_dependency('aequitas')
  s.add_dependency('bunny', '0.9.0.pre10')

  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('hashdiff')
  s.add_development_dependency('yard', '>= 0.7.0')
  s.add_development_dependency('yard-rspec', '0.1')
end
