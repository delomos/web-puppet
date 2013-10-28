# Class: supervisord
#
# A basic module to manage supervisord
#
# === Parameters
#  [*version*]
#    The package version to install
#
#  [*enable*]
#    Should the service be enabled at boot time?
#
#  [*start*]
#    Should the service be started by Puppet
class supervisord(
  $version = 'present',
  $enable = true,
  $start = true
) {
  class{'supervisord::install': } ->
  class{'supervisord::config': } ~>
  class{'supervisord::service': } ->
  Class['supervisord']
}
