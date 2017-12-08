require 'net/ssh'
require 'chef/config'

module KnifeSSHAgent
  module Authenticator
    def load_signing_key(key_file, raw_key = nil)
      use_agent  = Chef::Config[:knife][:use_ssh_agent]
      ident_file = Chef::Config[:knife][:ssh_agent_identity]

      return super(key_file, raw_key) unless use_agent

      @key = if ident_file
               load_ident_file(ident_file)
             else
               load_agent_default_ident
             end
    end

    def load_ident_file(path)
      file = [path + '.pub'].find(path) { |f| ::File.exist?(::File.expand_path(f)) }
      Net::SSH::KeyFactory.load_public_key(file)
    rescue Net::SSH::Exception
      raise AgentException, "unable to find requested SSH identity: #{path}"
    end

    def load_agent_default_ident
      agent = Net::SSH::Authentication::Agent.connect
      ident = agent.identities.select { |id| id.ssh_type == 'ssh-rsa' }

      raise AgentException, 'cannot retrieve a valid RSA key from the SSH agent' if ident.empty?
      ident.first
    ensure
      agent&.close
    end
  end
end
