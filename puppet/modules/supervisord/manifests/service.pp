# Class supervisord::service
#
# A basic class for managing the supervisord service
class supervisord::service {
  $ensure = $supervisord::start ? {true => running, default => stopped}

  exec { 'update-config':
    command     => 'supervisorctl update',
    refreshonly => true,
    subscribe   => File['/etc/supervisor/conf.d'],
  }

  service{'supervisor':
    ensure    => $ensure,
    enable    => $supervisord::enable,
    subscribe => Exec['update-config'],
  }

}
