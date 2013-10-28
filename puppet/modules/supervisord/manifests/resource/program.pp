# defined: supervisor::resource::program
#
# This definition creates a program config file
#
# Parameters:
#
#
# Actions:
#
# Requires:
#
# Sample Usage:
# supervisord::resource::program { 'helloworld':
#   ensure => present,
# }

define supervisord::resource::program(
  $ensure                  = 'enable',
  $command                 = false,
  $process_name            = '$(program_name)s',
  $numprocs                = 1,
  $numprocs_start          = 0,
  $priority                = 999,
  $autostart               = true,
  $autorestart             = 'unexpected',
  $startsecs               = 1,
  $startretries            = 3,
  $exitcodes               = '0,2',
  $stopsignial             = 'TERM',
  $stopwaitsecs            = 10,
  $stopasgroup             = false,
  $killasgroup             = false,
  $user                    = 'root',
  $redirect_stderr         = false,
  $stdout_logfile          = 'AUTO',
  $stdout_logfile_maxbytes = '50MB',
  $stdout_logfile_backups  = 10,
  $stdout_capture_maxbytes = 0,
  $stdout_events_enabled   = 0,
  $stderr_logfile          = 'AUTO',
  $stderr_logfile_maxbytes = '50MB',
  $stderr_logfile_backups  = 10,
  $stderr_capture_maxbytes = 0,
  $stderr_events_enabled   = false,
  $environment             = '',
  $directory               = '',
  $umask                   = '',
  $serverurl               = 'AUTO'
) {

  File {
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { "/etc/supervisor/conf.d/${name}.conf":
    content => template('supervisord/program.conf.erb'),
  } ~> Exec['update-config']

}

