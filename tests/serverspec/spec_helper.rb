require "serverspec"
require "rspec/retry"
require "specinfra"

set :backend, :ssh

options = Net::SSH::Config.for(host)
options[:host_name] = ENV["KITCHEN_HOSTNAME"]
options[:user]      = ENV["KITCHEN_USERNAME"]
options[:port]      = ENV["KITCHEN_PORT"]
options[:keys]      = ENV["KITCHEN_SSH_KEY"]

set :host,        options[:host_name]
set :ssh_options, options
set :env, LANG: "C", LC_ALL: "C"

RSpec.configure do |config|
  config.verbose_retry = true
  config.display_try_failure_messages = false
end

def ntpd_version
  Specinfra.backend.run_command("ntpd --version")
           .stdout.strip.sub(/@.*/, "").split(" ")[1]
end

def ntpd_supports_pool?
  Gem::Version.new(ntpd_version) >= Gem::Version.new("4.2.7")
end
