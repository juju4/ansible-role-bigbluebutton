require 'serverspec'

# Required by serverspec
set :backend, :exec

pkg_list = [ 'mongodb-org', 'bbb-check', 'bbb-html5', 'bigbluebutton' ]

for p in pkg_list do
  describe package("#{p}"), :if => os[:family] == 'ubuntu' || os[:family] == 'debian'  do
    it { should be_installed }
  end
end

describe service('bbb-html5') do
  it { should be_enabled }
  it { should be_running }
end
describe service('bbb-webrtc-sfu') do
  it { should be_enabled }
  it { should be_running }
end
describe service('bbb-web') do
  it { should be_enabled }
  it { should be_running }
end

describe process("node") do
  #its(:user) { should eq "bigbluebutton" }
  # its(:args) { should match /server.js/ }
  its(:count) { should eq 7 }
end

describe port(9001) do
  it { should be_listening.with('tcp') }
end
describe port(3010) do
  it { should be_listening.with('tcp') }
end

describe command('java -version') do
  its(:stdout) { should match /^$/ }
  its(:stderr) { should match /OpenJDK Runtime Environment \(build 1\.8/ }
  its(:exit_status) { should eq 0 }
end

describe docker_container('greenlight-v2') do
  it { should be_running }
end

describe docker_container('greenlight_db_1') do
  it { should be_running }
end

describe file('/var/log/bigbluebutton/bbb-web.log') do
  its(:content) { should_not match /ERROR/ }
end

describe command('curl -vk https://localhost') do
  its(:stdout) { should match /BigBlueButton - Open Source Web Conferencing/ }
  its(:stdout) { should match /Welcome Message & Login Into Demo/ }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/check') do
  its(:stdout) { should match /BigBlueButton - Open Source Web Conferencing/ }
  its(:stdout) { should match /Welcome Message & Login Into Demo/ }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/deskshare/') do
  its(:stdout) { should match /HTTP Status 404  Not Found/ }
  its(:stdout) { should match /Apache Tomcat/ }
  its(:stderr) { should match /HTTP\/1.1 404/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/close/') do
  its(:stdout) { should match /NetConnection.Connect.Rejected/ }
  its(:stdout) { should match /Bad request, only RTMPT supported/ }
  its(:stderr) { should match /400 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/html5client/') do
  its(:stdout) { should match /<script type="text\/javascript" src="\/html5client\// }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/html5client/join') do
  its(:stdout) { should match /DOCTYPE html/ }
  its(:stdout) { should match /__meteor_runtime_config__ = JSON.parse/ }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/bigbluebutton/') do
  its(:stdout) { should match /SUCCESS/ }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/pad/') do
  its(:stdout) { should match /doctype html/ }
  its(:stdout) { should match /<title>Etherpad<\/title>/ }
  its(:stdout) { should match /static\/skins\/no-skin\/index.js/ }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

# if greenlight
describe command('curl -vk https://localhost/b/') do
  its(:stdout) { should match /BigBlueButton/ }
  its(:stdout) { should match /Welcome to BigBlueButton./ }
  its(:stdout) { should match /Greenlight is a simple front-end for your BigBlueButton open-source web conferencing server/ }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end

## only if bbb-demo is present
#describe command('curl -vk https://localhost/demo/demoHTML5.jsp?username=test&isModerator=true&action=create') do
#  its(:stdout) { should match /BigBlueButton - Open Source Web Conferencing/ }
#  its(:stdout) { should match /Welcome Message & Login Into Demo/ }
#  its(:stderr) { should match /200 OK/ }
#  its(:stderr) { should_not match /No such file or directory/ }
#  its(:exit_status) { should eq 0 }
#end
#
#describe command('curl -vk https://localhost/demo/demo1.jsp?username=test&action=create') do
#  its(:stdout) { should match /BigBlueButton - Open Source Web Conferencing/ }
#  its(:stdout) { should match /Welcome Message & Login Into Demo/ }
#  its(:stderr) { should match /200 OK/ }
#  its(:stderr) { should_not match /An Error has occured:/ }
#  its(:stderr) { should_not match /No such file or directory/ }
#  its(:exit_status) { should eq 0 }
#end
