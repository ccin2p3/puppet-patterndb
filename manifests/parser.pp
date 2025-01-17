#
define patterndb::parser (
  Optional[Boolean] $test_before_deploy = undef,
  Optional[Array[String[1]]] $syslogng_modules = undef,
) {
  include patterndb
  if $syslogng_modules =~ Undef {
    $_modules = $patterndb::syslogng_modules
  } else {
    $_modules = $syslogng_modules
  }
  if empty($_modules) {
    $modules = ''
  } else {
    $tmp = join($_modules,' --module=')
    $modules = "--module=${tmp}"
  }
  ensure_resource('file', "${patterndb::config_dir}/${name}", {
      'ensure'  => 'directory',
      'purge'   => true,
      'force'   => true,
      'recurse' => true,
  })
  ensure_resource ('file', "${patterndb::cache_dir}/patterndb", {
      'ensure' => 'directory',
  })
  ensure_resource ('file', "patterndb::file::${name}", {
      'ensure' => 'present',
      'path'   => "${patterndb::var_dir}/patterndb/${name}.xml"
  })
  exec { "patterndb::merge::${name}":
    command     => "pdbtool merge -r --glob \\*.pdb -D ${patterndb::config_dir}/${name} -p ${patterndb::cache_dir}/patterndb/${name}.xml",
    path        => $facts['path'],
    logoutput   => true,
    refreshonly => true,
  }

  exec { "patterndb::test::${name}":
    #command    => "/usr/bin/pdbtool --validate test ${::patterndb::cache_dir}/patterndb/${name}.xml $modules",
    command     => "pdbtool test ${patterndb::cache_dir}/patterndb/${name}.xml ${modules}",
    path        => $facts['path'],
    logoutput   => true,
    refreshonly => true,
  }

  exec { "patterndb::deploy::${name}":
    command     => "cp ${patterndb::cache_dir}/patterndb/${name}.xml ${patterndb::var_dir}/patterndb/",
    logoutput   => true,
    path        => $facts['path'],
    refreshonly => true,
  }
  if $test_before_deploy =~ Undef {
    $_test_before_deploy = $patterndb::test_before_deploy
  } else {
    $_test_before_deploy = $test_before_deploy
  }
  if $_test_before_deploy {
    File["patterndb::file::${name}"]
    ~> Exec["patterndb::merge::${name}"]
    ~> Exec["patterndb::test::${name}"]
    ~> Exec["patterndb::deploy::${name}"]
  } else {
    File["patterndb::file::${name}"]
    ~> Exec["patterndb::merge::${name}"]
    # we won't 'pdbtool test' the merged file before deploying
    ~> Exec["patterndb::deploy::${name}"]
  }
}
