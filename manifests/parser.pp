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
  file { "${patterndb::config_dir}/${name}":
    ensure  => 'directory',
    purge   => true,
    force   => true,
    recurse => true,
  }
  ensure_resource ('file', "${patterndb::cache_dir}/patterndb", {
      'ensure' => 'directory',
  })
  exec { "patterndb::merge::${name}":
    command     => "pdbtool merge -r --glob \\*.pdb -D ${patterndb::config_dir}/${name} -p ${patterndb::cache_dir}/patterndb/${name}.xml",
    path        => $facts['path'],
    refreshonly => true,
  }

  $deploy_command = if $test_before_deploy.lest || { $patterndb::test_before_deploy } {
    "rm -f ${patterndb::var_dir}/patterndb/${name}.xml && pdbtool test ${patterndb::cache_dir}/patterndb/${name}.xml ${modules} && cp ${patterndb::cache_dir}/patterndb/${name}.xml ${patterndb::var_dir}/patterndb/${name}.xml"
  } else {
    "cp ${patterndb::cache_dir}/patterndb/${name}.xml ${patterndb::var_dir}/patterndb/${name}.xml"
  }

  exec { "patterndb::deploy::${name}":
    command   => $deploy_command,
    logoutput => true,
    path      => $facts['path'],
    onlyif    => "[ ! -f ${patterndb::var_dir}/patterndb/${name}.xml -o ${patterndb::cache_dir}/patterndb/${name}.xml -nt ${patterndb::var_dir}/patterndb/${name}.xml ]",
    require   => Exec["patterndb::merge::${name}"],
  }

  file { "patterndb::file::${name}":
    path    => "${patterndb::var_dir}/patterndb/${name}.xml",
    require => Exec["patterndb::deploy::${name}"],
  }
}
