# ensure git/python are installed
include git
include python

# install postgres
class { 'postgresql::server': 
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users => '0.0.0.0/0',
  listen_addresses => '*'
}

# set a postgres rule to allow for local askbout authentication
postgresql::server::pg_hba_rule { 'allow for local authentication with the askbot user':
  type => 'local',
  database => 'askbot',
  user => 'ab',
  auth_method => 'md5',
  order => 001
}

# uses our custom module to create 
# the askpgh db
class { 'db::create': }

# run dat update
exec { 'dat-update':
  command => 'sudo apt-get update',
  path => '/usr/bin'
}

# install python/postgres dev stuff
# need this for the psychopg2 library
exec { 'python-pg-dev':
  command => 'sudo apt-get install -y postgresql-server-dev-9.3 python-dev',
  path => '/usr/bin',
  require => Exec['dat-update']
}

# install necessary python libs
python::pip { 'psycopg2' :
  pkgname => 'psycopg2',
  ensure => 'present',
  require => Exec['python-pg-dev']
}

# install askbot from the pip universe
python::pip { 'askbot' :
  pkgname => 'askbot',
  ensure => '0.7.50'
}

# setup askbot environment
exec { 'askbot-site' :
  command => 'askbot-setup -n /home/vagrant/ab -e 1 -u ab -p ab -d askbot',
  path => '/usr/local/bin',
  require => Python::Pip['psycopg2', 'askbot']
}

# make sure that the askbot skins directory exists
file { '/home/vagrant/ab/askbot/skins' : 
  ensure => 'directory',
  require => Exec['askbot-site']
}

# copy over the setup script
file { '/usr/local/bin/ab-setup' :
  source => '/vagrant/files/ab-setup.sh',
  mode => '+x',
  require => Exec['askbot-site']
}

# copy over a script that can startup the askbot server
file { '/usr/local/bin/run-askbot' :
  source => '/vagrant/files/run-askbot.sh',
  mode => '+x',
  require => Exec['askbot-site']
}

# copy over the default settings file
file { '/home/vagrant/ab/settings.py' :
  source => '/vagrant/files/settings.py',
  require => Exec['askbot-site']
}

# make sure to set sane ownership values for the ab directory
file { '/home/vagrant/ab' :
  ensure => 'directory',
  owner => 'vagrant',
  group => 'vagrant',
  require => Exec['askbot-site']
}