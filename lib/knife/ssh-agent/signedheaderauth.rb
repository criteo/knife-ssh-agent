require 'net/ssh'
require 'chef/config'
require 'mixlib/authentication'

module KnifeSSHAgent
  SSH_AGENT_RSA_SHA2_256 = Net::SSH::Authentication::Agent::SSH_AGENT_RSA_SHA2_256

  module SigningObject
    def do_sign(private_key, digest, sign_algorithm, sign_version)
      use_agent = Chef::Config[:knife][:use_ssh_agent]

      if use_agent
        sign_with_agent(private_key, sign_algorithm, sign_version)
      else
        super(private_key, digest, sign_algorithm, sign_version)
      end
    end

    def sign_with_agent(key, sign_algorithm, sign_version)
      raise AgentException, 'ssh-agent requires authentication_protocol_version 1.3' unless sign_version == '1.3'

      string_to_sign = canonicalize_request(sign_algorithm, sign_version)
      begin
        agent = Net::SSH::Authentication::Agent.connect
        blob  = Net::SSH::Buffer.from(:raw, agent.sign(key, string_to_sign, SSH_AGENT_RSA_SHA2_256))
        type  = blob.read_string

        raise AgentException, "agent returned a '#{type}' signature (should be 'rsa-sha2-256')" unless type == 'rsa-sha2-256'

        blob.read_string
      ensure
        agent&.close
      end
    end
  end
end
