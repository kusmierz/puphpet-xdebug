define xdebug::augeas (
  $value    = '',
  $ini_file = $xdebug::params::ini_file,
  $ensure   = present,
  $service = 'httpd',
  ) {

  include xdebug

  $changes = $ensure ? {
    present => [ "set '${name}' '${value}'" ],
    absent  => [ "rm '${name}'" ],
  }

  augeas { "xdebug_ini-${name}":
    context => "${ini_file}/Xdebug",
    lens    => 'Php.lns',
    changes => [
      "set PermitRootLogin no",
    ],
    notify  => Service[$service],
  }
}
