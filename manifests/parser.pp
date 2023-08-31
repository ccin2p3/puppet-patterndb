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

  file { "${patterndb::pdb_dir}/${name}":
    ensure  => 'directory',
    force   => true,
    recurse => true,
    purge   => true,
  }

  ensure_resource ('file', "${patterndb::temp_dir}/patterndb", {
      'ensure' => 'directory',
  })

  $_test_before_deploy = $test_before_deploy.lest || { $patterndb::test_before_deploy }

  exec { "patterndb::merge::${name}":
    command     => "pdbtool merge -r --glob \\*.pdb -D ${patterndb::pdb_dir}/${name} -p ${patterndb::temp_dir}/patterndb/${name}.xml",
    path        => $facts['path'],
    logoutput   => true,
    refreshonly => true,
  }

  $deploy_command = if $_test_before_deploy {
    "pdbtool test ${patterndb::temp_dir}/patterndb/${name}.xml ${modules} && cp ${patterndb::temp_dir}/patterndb/${name}.xml ${patterndb::base_dir}/var/lib/syslog-ng/patterndb/${name}.xml"
  } else {
    "cp ${patterndb::temp_dir}/patterndb/${name}.xml ${patterndb::base_dir}/var/lib/syslog-ng/patterndb/${name}.xml"
  }

  exec { "patterndb::deploy::${name}":
    command   => $deploy_command,
    path      => $facts['path'],
    logoutput => true,
    onlyif    => "[ ! -f ${patterndb::base_dir}/var/lib/syslog-ng/patterndb/${name}.xml -o ${patterndb::temp_dir}/patterndb/${name}.xml -nt ${patterndb::base_dir}/var/lib/syslog-ng/patterndb/${name}.xml ]",
    require   => Exec["patterndb::merge::${name}"],
  }
}
