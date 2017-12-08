lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'knife/ssh-agent/version'

Gem::Specification.new do |spec|
  spec.name          = 'knife-ssh-agent'
  spec.version       = KnifeSSHAgent::VERSION
  spec.authors       = ['Vincent Minet']
  spec.email         = ['v.minet@criteo.com']
  spec.homepage      = 'https://github.com/criteo/knife-ssh-agent'
  spec.license       = 'MIT'
  spec.summary       = 'SSH Agent support for chef authentication'
  spec.description   = 'Authenticate to a chef server using a SSH agent.'

  spec.require_paths = 'lib'
  spec.files         = `git ls-files -z`.split("\x0")

  spec.add_development_dependency 'bundler', '>= 1.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'chef'
  spec.add_dependency 'net-ssh', '>= 4.2'
end
