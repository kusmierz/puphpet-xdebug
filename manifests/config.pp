define xdebug::config (
  $default_enable        = 1,
  $remote_autostart      = 1,
  $remote_connect_back   = 1,
  $remote_enable         = 1,
  $remote_handler        = 'dbgp',
  $remote_host           = $ipaddress_eth1,
  $remote_mode           = 'req',
  $remote_port           = 9000,
  $show_exception_trace  = 0,
  $show_local_vars       = 0,
  $var_display_max_data  = 10000,
  $var_display_max_depth = 20,
  $ini_file              = undef,
) {

  if (!$ini_file) {
    # guess the ini file as fallback
    if $name == 'cgi' {
      $ini_file_real = "${php::config_dir}/${php::service}/php.ini"
    } elsif $name == 'cli' {
      $ini_file_real = "${php::config_dir}/cli/php.ini"
    } else {
      $ini_file_real = "${php::config_file}"
    }
  } else {
    $ini_file_real = $ini_file
  }

  $vars = {
    default_enable        => $default_enable,
    remote_autostart      => $remote_autostart,
    remote_connect_back   => $remote_connect_back,
    remote_enable         => $remote_enable,
    remote_handler        => $remote_handler,
    remote_host           => $remote_host,
    remote_mode           => $remote_mode,
    remote_port           => $remote_port,
    show_exception_trace  => $show_exception_trace,
    show_local_vars       => $show_local_vars,
    var_display_max_data  => $var_display_max_data,
    var_display_max_depth => $var_display_max_depth,
    ini                   => $ini_file_real
  }

  puphpet::ini::removeblock { "xdebug-${name}":
    block_name => 'xdebug',
    ini_file   => $ini_file_real
  }

  file_line { $ini_file_real:
    ensure  => present,
    line    => template('xdebug/ini_file.erb'),
    path    => $ini_file_real,
    require => Puphpet::Ini::Removeblock["xdebug-${name}"],
  }

  # shortcut for xdebug CLI debugging
  if ! defined(File['/usr/bin/xdebug']) {
    file { '/usr/bin/xdebug':
      ensure => 'present',
      mode   => '+X',
      source => 'puppet:///modules/xdebug/cli_alias.erb'
    }
  }

}
