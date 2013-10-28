# Class supervisord::install
#
# A basic class to install supervisord
class supervisord::install {

  package {'supervisor':
    ensure => $supervisord::ensure
  }

}
