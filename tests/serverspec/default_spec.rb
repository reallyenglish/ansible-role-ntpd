require 'spec_helper'
require 'serverspec'

package = 'ntpd'
service = 'ntpd'
config  = '/etc/ntp.conf'
ports   = [ 123 ]

case os[:family]
when 'freebsd'
  db_dir = '/var/db/ntpd'
end

case os[:family]
when 'freebsd'
else
  describe package(package) do
    it { should be_installed }
  end 
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape('server 0.pool.ntp.org') }
  its(:content) { should match Regexp.escape('server 1.pool.ntp.org') }
  its(:content) { should match Regexp.escape('server 2.pool.ntp.org') }
  its(:content) { should match Regexp.escape('server 3.pool.ntp.org') }
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end
