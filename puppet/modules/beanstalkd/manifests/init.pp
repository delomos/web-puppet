class beanstalkd {
    package { 'beanstalkd':
        ensure => present,
        require => Class['::apt::update']
    }
}