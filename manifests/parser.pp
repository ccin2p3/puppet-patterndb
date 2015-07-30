#
define patterndb::parser (
  $test_before_deploy = $::patterndb::test_before_deploy,
  $syslogng_modules = $::patterndb::syslogng_modules
) {
  if ! defined(Class['Patterndb']) {
    include ::patterndb
  }
  if empty($syslogng_modules) {
    $modules = undef
  } else {
    $tmp = join($syslogng_modules,' --module=')
    $modules = "--module=${tmp}"
  }
  ensure_resource('file', "${::patterndb::pdb_dir}/${name}", {
    'ensure'          => 'directory',
    'purge'       => true,
    'recurse' => true,
  })
  ensure_resource ('file', "${::patterndb::temp_dir}/patterndb", {
    'ensure' => 'directory',
  })
  ensure_resource ('file', "patterndb::file::${name}", {
    'ensure' => 'present',
    'path'   => "${::patterndb::base_dir}/var/lib/syslog-ng/patterndb/${name}.xml"
  })
  exec { "patterndb::merge::${name}":
    command => "pdbtool merge -r --glob \\*.pdb -D ${::patterndb::pdb_dir}/${name} -p ${::patterndb::temp_dir}/patterndb/${name}.xml",
    path => $::path,
    logoutput => true,
    refreshonly => true,
  }

  exec { "patterndb::test::${name}":
    #command  => "/usr/bin/pdbtool --validate test ${::patterndb::temp_dir}/patterndb/${name}.xml $modules",
    command  => "pdbtool test ${::patterndb::temp_dir}/patterndb/${name}.xml ${modules}",
    path => $::path,
    logoutput => true,
    refreshonly => true,
  }

  exec { "patterndb::deploy::${name}":
    command => "cp ${::patterndb::temp_dir}/patterndb/${name}.xml ${::patterndb::base_dir}/var/lib/syslog-ng/patterndb/",
    path => $::path,
    logoutput => true,
    refreshonly => true
  }
  if $test_before_deploy {
    File["patterndb::file::${name}"] ~>
    Exec["patterndb::merge::${name}"] ~>
    Exec["patterndb::test::${name}"] ~>
    Exec["patterndb::deploy::${name}"]
    } else {
      File["patterndb::file::${name}"] ~>
      Exec["patterndb::merge::${name}"] ~>
      # we won't 'pdbtool test' the merged file before deploying
      Exec["patterndb::deploy::${name}"]
    }
}
