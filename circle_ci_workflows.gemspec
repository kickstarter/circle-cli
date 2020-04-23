
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'circle_ci_workflows/version'

Gem::Specification.new do |spec|
  spec.name          = 'circle_ci_workflows'
  spec.version       = CircleCiWorkflows::VERSION
  spec.authors       = ['Oliver Switzer', 'Philippe Creux']
  spec.email         = ['oliverswitzer@gmail.com']

  spec.summary       = 'A visual CLI that allows you to watch Circle CI workflows from the terminal and be notified of their completion'
  spec.description   = ''
  spec.homepage      = 'https://github.com/oliverswitzer/circle_ci_workflows'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://mygemserver.com"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['workflow']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10.4'

  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'http'
  spec.add_runtime_dependency 'thor'
end
