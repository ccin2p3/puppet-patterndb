#
class { 'patterndb':
  manage_package   => false,
  syslogng_modules => [],
}

patterndb::raw::ruleset { 'raw':
  source => 'puppet:///modules/patterndb/tests/raw.pdb',
}

patterndb::raw::ruleset { 'raw.d':
  ensure => 'directory',
  source => 'puppet:///modules/patterndb/tests/raw.d',
}
