require 'knife/ssh-agent'
require 'chef/http/authenticator'
require 'mixlib/authentication/signedheaderauth'

Chef::HTTP::Authenticator.prepend(KnifeSSHAgent::Authenticator)
Mixlib::Authentication::SigningObject.prepend(KnifeSSHAgent::SigningObject)
