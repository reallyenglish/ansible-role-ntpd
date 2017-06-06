require "spec_helper"

package = "ntp"
service = "ntp"
config  = "/etc/ntp.conf"
db_dir  = "/var/lib/ntp"
pool_base = "pool.ntp.org"

case os[:family]
when "freebsd"
  db_dir = "/var/db/ntp"
  service = "ntpd"
when "redhat"
  service = "ntpd"
end
puts os[:family]

leap_file = "#{db_dir}/leap-seconds.list"

unless os[:family] == "freebsd"
  describe package(package) do
    it { should be_installed }
  end
end

case os[:family]
when "redhat"
  describe package("libselinux-python") do
    it { should be_installed }
  end
end

describe file(config) do
  it { should be_file }
  its(:content) { should match(/^restrict localhost$/) }
  its(:content) { should match Regexp.escape("leapfile \"#{leap_file}\"") }
  its(:content) { should match Regexp.escape("driftfile \"#{db_dir}/ntp.drift\"") }
  its(:content) { should match Regexp.escape("server time1.google.com iburst") }
  its(:content) { should match Regexp.escape("server time2.google.com iburst") }
  its(:content) { should match Regexp.escape("server time3.google.com iburst") }
  its(:content) { should match Regexp.escape("server time4.google.com iburst") }
  its(:content) { should match Regexp.escape("restrict time1.google.com nomodify notrap noquery") }
  its(:content) { should match Regexp.escape("restrict time2.google.com nomodify notrap noquery") }
  its(:content) { should match Regexp.escape("restrict time3.google.com nomodify notrap noquery") }
  its(:content) { should match Regexp.escape("restrict time4.google.com nomodify notrap noquery") }
  if ntpd_supports_pool?
    its(:content) { should match(/^restrict default ignore$/) }
    its(:content) { should match Regexp.escape("restrict -6 default ignore") }
    its(:content) { should match Regexp.escape("pool 0.#{pool_base} iburst") }
    its(:content) { should match(/^restrict source nomodify noquery notrap$/) }
  else
    its(:content) { should match Regexp.escape("restrict default -4 nomodify nopeer noquery notrap") }
    its(:content) { should match Regexp.escape("restrict default -6 nomodify nopeer noquery notrap") }
    its(:content) { should match Regexp.escape("server 0.#{pool_base} iburst") }
    its(:content) { should match Regexp.escape("server 1.#{pool_base} iburst") }
    its(:content) { should match Regexp.escape("server 2.#{pool_base} iburst") }
    its(:content) { should match Regexp.escape("server 3.#{pool_base} iburst") }
  end
end

describe file(leap_file) do
  it { should be_file }
  its(:content) { should match(/2272060800\s+10\s+/) }
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

describe command("ntpq -pn") do
  its(:stderr) { should_not match(/timed out/) }
  its(:stderr) { should eq("") }
end

describe "ntpd sync", retry: 30, retry_wait: 1 do
  it "synced to a server" do
    expect(command("ntpq -pn").stdout).to match(/\*\d+\.\d+\.\d+\.\d+ /)
  end
  it "reaches all servers" do
    expect(command("ntpq -pn").stdout).not_to match(/\.INIT\./)
  end
end
