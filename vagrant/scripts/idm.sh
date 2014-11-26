#!/bin/bash
MYSQL_ROOT_PW="rootpw"
HOST_NAME=$(hostname -f)
IDM_HOST_NAME="idm.${HOST_NAME}"
IDM_DBNAME="idmdb"
IDM_DBUSER="idmdbuser"
IDM_DBPASS="idmdbpass"

# update package list
apt-get -qy update

# install apache with passenger
apt-get install -qy apache2 libapache2-mod-passenger

# install idm dependencies
apt-get install -qy git ruby1.9.1 ruby1.9.1-dev build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config libmysqlclient-dev imagemagick graphicsmagick libmagickwand-dev sendmail-bin libreadline-dev libxslt1-dev libcurl4-openssl-dev

apt-get install -qy nodejs nodejs-legacy
apt-get install -qy bundler

# install and configure mysql
echo "Installing MySQL 5.5"
apt-get install -qqy debconf-utils
cat << EOF | debconf-set-selections
mysql-server-5.5 mysql-server/root_password password $MYSQL_ROOT_PW
mysql-server-5.5 mysql-server/root_password_again password $MYSQL_ROOT_PW
mysql-server-5.5 mysql-server/root_password seen true
mysql-server-5.5 mysql-server/root_password_again seen true
EOF
apt-get -qy install mysql-server

cat <<EOF | mysql --user=root --password=$MYSQL_ROOT_PW
create database $IDM_DBNAME;
create user $IDM_DBUSER@localhost identified by '$IDM_DBPASS';
grant all privileges on $IDM_DBNAME.* to $IDM_DBUSER@localhost;
flush privileges;
EOF

# vhost http
cat <<EOF > /etc/apache2/sites-available/idm.conf
<VirtualHost *:80>
    ServerName $IDM_HOST_NAME
    ServerAlias $HOST_NAME

    # DocumentRoot [root to your app./public]
    DocumentRoot /home/idm-deploy/fi-ware-idm/current/public

    # Directory [root to your app./public]
    <Directory /home/idm-deploy/fi-ware-idm/current/public>
        Require all granted
    </Directory>

</VirtualHost>
EOF

# vhost https
cat <<EOF > /etc/apache2/sites-available/idm-ssl.conf
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerName $IDM_HOST_NAME
                ServerAlias $HOST_NAME

                DocumentRoot /home/idm-deploy/fi-ware-idm/current/public

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on

                SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem
                SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>

                BrowserMatch "MSIE [2-6]" \
                                nokeepalive ssl-unclean-shutdown \
                                downgrade-1.0 force-response-1.0
                # MSIE 7 and newer should be able to use keepalive
                BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

                <Directory /home/idm-deploy/fi-ware-idm/current/public>
                        Require all granted
                </Directory>

        </VirtualHost>
</IfModule>
EOF

# enable vhosts
a2ensite idm
a2ensite idm-ssl
a2dissite 000-default

# enable modules
a2enmod ssl
a2enmod passenger
service apache2 restart

# deploy user
adduser --disabled-password --gecos "idm deploy" idm-deploy
su - idm-deploy -c "mkdir -p /home/idm-deploy/.ssh"
su - idm-deploy -c "mkdir -p /home/idm-deploy/fi-ware-idm/shared/config"
su - idm-deploy -c "mkdir -p /home/idm-deploy/fi-ware-idm/shared/config/initializers"

# source user
adduser --disabled-password --gecos "idm source" idm-source
adduser idm-source sudo
cat <<EOF > /etc/sudoers.d/idm-source
idm-source ALL=(ALL) NOPASSWD:ALL
EOF
chmod 0440 /etc/sudoers.d/idm-source

su - idm-source -c "ssh-keygen -t rsa -b 4096 -f /home/idm-source/.ssh/deploy -P ''"
su - idm-source -c "ssh-keyscan -H $HOST_NAME >> /home/idm-source/.ssh/known_hosts"

cat /home/idm-source/.ssh/deploy.pub >> /home/idm-deploy/.ssh/authorized_keys
chown idm-deploy:idm-deploy /home/idm-deploy/.ssh/authorized_keys

cat <<EOF > /home/idm-source/.ssh/config
Host $HOST_NAME
    User idm-deploy
    IdentityFile /home/idm-source/.ssh/deploy
EOF
chown idm-source:idm-source /home/idm-source/.ssh/config

# prepare for deploy
cat <<EOF > /home/idm-source/idm-source.sh
cd $HOME
git clone https://github.com/ging/fi-ware-idm
cd fi-ware-idm
sed -i Gemfile \
  -e "/gem 'mysql2'/a  gem 'net-ssh'" \
  -e "/gem \"capistrano\",/c\  gem 'capistrano', '~> 3.1.0'\n\  gem 'capistrano-bundler', '~> 1.1.2'\n\  gem 'capistrano-rails', '~> 1.1.1'"
bundle --binstubs
rm Capfile
cap install STAGES=production
sed -i Capfile \
  -e "/require 'capistrano\/deploy'/a require 'capistrano\/bundler'\nrequire 'capistrano\/rails'"
cat << __EOF__ > config/deploy.rb
# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'fi-ware-idm'
set :repo_url, 'https://github.com/ging/fi-ware-idm.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/idm-deploy/fi-ware-idm'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/initializers/0fiware.rb config/initializers/thales.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

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

cat << __EOF__ > config/deploy/production.rb
role :app, %w{$HOST_NAME}
role :web, %w{$HOST_NAME}
role :db,  %w{$HOST_NAME}
set :stage, :production
server '$HOST_NAME', user: 'idm-deploy', roles: %w{web app}
__EOF__

cat << __EOF__ > config/database.yml
production:
  adapter: mysql2
  database: $IDM_DBNAME
  encoding: utf8
  username: $IDM_DBUSER
  password: $IDM_DBPASS
  host: localhost
  port: 3306
  socket: /var/run/mysqld/mysqld.sock
__EOF__

cp config/initializers/0fiware.rb.example config/initializers/0fiware.rb
sed -i config/initializers/0fiware.rb \
  -e "/# config.domain/a config.domain = '${IDM_HOST_NAME}'" \
  -e "/# config.subdomain/a config.subdomain = '${HOST_NAME}'" \
  -e "/# config.sender/a config.sender = 'no-reply@${IDM_HOST_NAME}'"

# TODO: add a proper thales.rb
touch config/initializers/thales.rb

scp config/database.yml idm-deploy@${HOST_NAME}:fi-ware-idm/shared/config/
scp config/initializers/0fiware.rb idm-deploy@${HOST_NAME}:fi-ware-idm/shared/config/initializers/
scp config/initializers/thales.rb idm-deploy@${HOST_NAME}:fi-ware-idm/shared/config/initializers/
cap production deploy
EOF
chmod +x /home/idm-source/idm-source.sh
su - idm-source -c "/home/idm-source/idm-source.sh"

# cleanup
#rm /home/idm-source/idm-source.sh

# TODO: edit /etc/hosts to add the full hostname
