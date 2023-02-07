#
define patterndb::raw::ruleset (
  String[1] $source,
  Enum['absent', 'directory', 'present'] $ensure = 'present',
  Boolean $recurse = true,
  Boolean $purge = true,
  String[1] $sourceselect = 'all',
  String[1] $parser = 'default',
  Array[String[1]] $ignore = ['.svn', '.git'],
) {
  if ! defined(Class['Patterndb']) {
    include patterndb
  }

  if ! defined(Patterndb::Parser[$parser]) {
    patterndb::parser { $parser:
      test_before_deploy => $patterndb::test_before_deploy,
      syslogng_modules   => $patterndb::syslogng_modules,
    }
  }

  if $ensure == 'directory' {
    file { "${patterndb::pdb_dir}/${parser}/${name}":
      ensure       => $ensure,
      recurse      => $recurse,
      mode         => '0644',
      purge        => $purge,
      source       => $source,
      sourceselect => $sourceselect,
      ignore       => $ignore,
      notify       => Exec["patterndb::merge::${parser}"],
    }
  } else {
    file { "${patterndb::pdb_dir}/${parser}/${name}.pdb":
      ensure => $ensure,
      mode   => '0644',
      source => $source,
      notify => Exec["patterndb::merge::${parser}"],
    }
  }
}
