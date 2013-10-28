$rootpath = "/vagrant"

$packagesdir = "/etc/packages"

file { "packagedir" :
  path   => "/etc/packages",
  ensure => "directory",
} 


group { 'puppet': ensure => present }

Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

# include NodeJS
class prepare {
  apt::ppa { 'ppa:chris-lea/node.js': }
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>

    apt::key { '4F4EA0AAE5267A6C': }

apt::ppa { 'ppa:ondrej/php5-oldstable':
  require => Apt::Key['4F4EA0AAE5267A6C']
}

class { 'puphpet::dotfiles': }

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core',
    'wget',
    'git-flow',
    'sqlite3',
    'tree'
  ]:
  ensure  => 'installed',
}

class { 'apache': }

apache::dotconf { 'custom':
  content => 'EnableSendfile Off',
}

apache::module { 'rewrite': }


apache::vhost { 'web.dev':
  server_name   => 'web.dev',
  serveraliases => [
    'www.web.dev',
    'web.local'
  ],
  docroot       => '/var/www/public',
  port          => '80',
  env_variables => [
],
  priority      => '1',
}

apache::vhost { 'beanstalkd':
  server_name   => 'beanstalkd',
  serveraliases => [
    'beanstalkd.dev',
    'beanstalkd.local'
  ],
  docroot       => '/etc/packages/tools/phpBeanstalkdAdmin/public',
  port          => '80',
  env_variables => [
],
  priority      => '1',
}

class { 'php':
  service             => 'apache',
  service_autorestart => false,
  module_prefix       => '',
}

php::module { 'php5-mysql': }
php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }
php::module { 'php5-sqlite': }
php::module { 'php5-xsl': }
php::module { 'php5-memcached': }



class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}



if !defined(Package['git-core']) {
  package { 'git-core' : }
}



class { 'xdebug':
  service => 'apache',
}


puphpet::ini { 'xdebug':
  value   => [
    'xdebug.default_enable = 1',
    'xdebug.remote_autostart = 0',
    'xdebug.remote_connect_back = 1',
    'xdebug.remote_enable = 1',
    'xdebug.remote_handler = "dbgp"',
    'xdebug.remote_host = "10.1.10.110"',
    'xdebug.remote_port = 9000',
    'xdebug.idekey =  "vagrant"',
    'xdebug.remote_log="/var/log/xdebug/xdebug.log"'
  ],
  ini     => '/etc/php5/conf.d/zzz_xdebug.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

puphpet::ini { 'php':
  value   => [
    'date.timezone = "America/New_York"'
  ],
  ini     => '/etc/php5/conf.d/zzz_php.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

puphpet::ini { 'custom':
  value   => [
    'display_errors = On',
    'error_reporting = -1'
  ],
  ini     => '/etc/php5/conf.d/zzz_custom.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

class { 'mysql::server':
  config_hash   => { 'root_password' => 'local' }
}

mysql::db { 'web':
  grant    => [
    'ALL'
  ],
  user     => 'web',
  password => 'local',
  host     => '%',
  charset  => 'utf8',
  require  => Class['mysql::server'],
}

class { 'phpmyadmin':
  require => [Class['mysql::server'], Class['mysql::config'], Class['php']],
}

apache::vhost { 'phpmyadmin':
  server_name => 'phpmyadmin',
  docroot     => '/usr/share/phpmyadmin',
  port        => 80,
  priority    => '10',
  require     => Class['phpmyadmin'],
}
include laravel-app

include beanstalkd

# Start beanstalkd
file { "/etc/default/beanstalkd":
  ensure => present,
  source => "/vagrant/puppet/templates/beanstalkd/default",
 require => Package["beanstalkd"]
}

file { "/etc/init.d/beanstalkd":
  ensure => present,
  source => "/vagrant/puppet/templates/beanstalkd/init.d",
  require => Package["beanstalkd"]
}

# http://mnapoli.github.io/phpBeanstalkdAdmin/
exec {
 "install_beanstalk_console":
  command => "git clone https://github.com/mnapoli/phpBeanstalkdAdmin.git /etc/packages/tools/phpBeanstalkdAdmin",
   require => [ Package['git-core'], File["packagedir"] ],
   unless => "[ -d '/etc/packages/tools/phpBeanstalkdAdmin' ]"
}

include supervisord

supervisord::resource::program {'web_queue':
  command       => '/usr/bin/php /vagrant/artisan queue:listen --env=production --timeout=8000 --memory=256 -n -v',
  environment   => 'COMPOSER_PROCESS_TIMEOUT=8000',
  process_name  => '%(process_num)s',
  numprocs      => 2,
  directory => $rootpath
}

include prepare

package {'nodejs': ensure => present, require => Class['prepare'],}

package {['brunch']:
    ensure   => present,
    provider => 'npm',
    require  => Package['nodejs'],
}

package { 'compass':
    ensure   => 'installed',
    provider => 'gem',
}
