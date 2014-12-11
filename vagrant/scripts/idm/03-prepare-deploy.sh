#!/bin/bash

su - idm-source <<EOF
# clone idm repository
git clone https://github.com/ging/fi-ware-idm

cd fi-ware-idm

# fix Gemfile for Capistrano 3
sed -i Gemfile \
  -e "/gem 'mysql2'/a  gem 'net-ssh'" \
  -e "/gem \"capistrano\",/c\  gem 'capistrano', '~> 3.1.0'\n\  gem 'capistrano-bundler', '~> 1.1.2'\n\  gem 'capistrano-rails', '~> 1.1.1'"

bundle --binstubs

# fix Capfile for Capistrano 3
rm Capfile
cap install STAGES=production
sed -i Capfile \
  -e "/require 'capistrano\/deploy'/a require 'capistrano\/bundler'\nrequire 'capistrano\/rails'"

# create config/deploy.rb
cat << __EOF__ > config/deploy.rb
# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'fi-ware-idm'
set :repo_url, 'https://github.com/ging/fi-ware-idm.git'
set :deploy_to, '/home/idm-deploy/fi-ware-idm'
set :linked_files, %w{config/database.yml config/initializers/0fiware.rb config/initializers/thales.rb app/models/application.rb app/models/xacml_file_keypass.rb app/models/xacml_policy_keypass.rb config/initializers/keypass.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
__EOF__

# create config/deploy/production.rb
cat << __EOF__ > config/deploy/production.rb
role :app, %w{${HOSTNAME}}
role :web, %w{${HOSTNAME}}
role :db,  %w{${HOSTNAME}}
set :stage, :production
server '${HOSTNAME}', user: 'idm-deploy', roles: %w{web app}
__EOF__

# database configuration
cat << __EOF__ > config/database.yml
production:
  adapter: mysql2
  database: ${IDM_DBNAME}
  encoding: utf8
  username: ${IDM_DBUSER}
  password: ${IDM_DBPASS}
  host: localhost
  port: 3306
  socket: /var/run/mysqld/mysqld.sock
__EOF__

# fiware domain configuration
cp config/initializers/0fiware.rb.example config/initializers/0fiware.rb
sed -i config/initializers/0fiware.rb \
  -e "/# config.domain/a config.domain = '${IDM_HOSTNAME}'" \
  -e "/# config.subdomain/a config.subdomain = '${HOSTNAME}'" \
  -e "/# config.sender/a config.sender = 'no-reply@${IDM_HOSTNAME}'"

# TODO: add a proper thales.rb
touch config/initializers/thales.rb

# upload configuration files to deploy
scp config/database.yml ${HOSTNAME}:fi-ware-idm/shared/config/
scp config/initializers/0fiware.rb ${HOSTNAME}:fi-ware-idm/shared/config/initializers/
scp config/initializers/thales.rb ${HOSTNAME}:fi-ware-idm/shared/config/initializers/
scp -r ${SCRIPTS_PATH}/idm/patches/* ${HOSTNAME}:fi-ware-idm/shared/

EOF
