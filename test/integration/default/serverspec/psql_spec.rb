require 'serverspec'

# Required by serverspec
set :backend, :exec

describe command("docker exec greenlight_db_1 psql -nqw -U postgres greenlight_production -c '\\dt'") do
  its(:stdout) { should match /ar_internal_metadata/ }
  its(:stdout) { should match /invitations/ }
  its(:stdout) { should match /users_roles/ }
  its(:stdout) { should_not match /No relations found./ }
  its(:stderr) { should_not match /FATAL/ }
  its(:exit_status) { should eq 0 }
end

describe command("docker exec greenlight_db_1 psql -nqw -U postgres greenlight_production -c 'select * from users;'") do
  its(:stdout) { should match /users/ }
  its(:stdout) { should match /email/ }
  its(:stdout) { should_not match /No relations found./ }
  its(:stderr) { should_not match /FATAL/ }
  its(:exit_status) { should eq 0 }
end
