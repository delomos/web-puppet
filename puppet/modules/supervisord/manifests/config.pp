# Class supervisord::config
#
# A basic class for managing the config of supervisord
#
# This class file is not called directly
class supervisord::config (
  $childlogdir = '/var/log/supervisor',
) {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/supervisor/supervisord.conf':
    ensure  => file,
    content => template('supervisord/supervisord.conf.erb'),
  }

  file { '/etc/supervisor/conf.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

}

