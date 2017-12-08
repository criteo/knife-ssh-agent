require 'knife/ssh-agent/authenticator'
require 'knife/ssh-agent/signedheaderauth'

module KnifeSSHAgent
  class AgentException < RuntimeError; end
end
