class xdebug::params {

  $install_cli = true

  case $::osfamily {
    'Debian': {
      $pkg = 'php5-xdebug'
      $php = 'php5-cli'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
