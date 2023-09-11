#
class { 'patterndb':
  manage_package   => false,
  syslogng_modules => [],
  use_hiera        => true,
}

patterndb::parser { 'default': }
