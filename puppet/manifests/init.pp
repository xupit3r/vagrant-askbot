# ensure git/python are installed
include git
include python

# install postgres
class { 'postgresql::server': 
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users => '0.0.0.0/0',
  listen_addresses => '*'
}

postgresql::server::pg_hba_rule { 'allow for local authentication with the askbot user':
  type => 'local',
  database => 'omain',
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
  ensure => 'present'
}

# setup askbot environment
exec { 'askbot-site' :
  command => 'askbot-setup -n /home/vagrant/ab -e 1 -d ab -u ab -p ab -domain askbot.dev',
  path => '/usr/local/bin',
  require => Python::Pip['psycopg2', 'askbot']
}

file { '/home/vagrant/ab/askbot/skins' : 
  ensure => 'directory',
  require => Exec['askbot-site']
}

file { '/home/vagrant/ab/ab-setup.sh' :
  source => '/vagrant/files/ab-setup.sh',
  mode => '+x',
  require => Exec['askbot-site']
}