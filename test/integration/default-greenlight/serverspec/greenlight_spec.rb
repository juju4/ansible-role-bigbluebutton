require 'serverspec'

# Required by serverspec
set :backend, :exec

describe docker_container('greenlight-v2') do
  it { should be_running }
end

describe docker_container('greenlight_db_1') do
  it { should be_running }
end

describe command('docker run --rm --env-file /root/greenlight/.env bigbluebutton/greenlight:v2 bundle exec rake conf:check') do
  its(:stdout) { should match /Checking environment: Passed/ }
  its(:stderr) { should_not match /No such file or directory/ }
  # No greenlight option to validate self-signed certificate so following test will fail in test mode
  # will also result in user error after login 'Error connecting to BigBlueButton server'
  its(:stdout) { should_not match /Checking Connection: Failed/ }
  its(:stdout) { should_not match /Error connecting to BigBlueButton server/ }
  its(:exit_status) { should eq 0 }
end

describe command('curl -vk https://localhost/b/') do
  its(:stdout) { should match /BigBlueButton/ }
  its(:stdout) { should match /Welcome to BigBlueButton./ }
  its(:stdout) { should match /Greenlight is a simple front-end for your BigBlueButton open-source web conferencing server/ }
  its(:stderr) { should match /200 OK/ }
  its(:stderr) { should_not match /No such file or directory/ }
  its(:exit_status) { should eq 0 }
end
