#
class patterndb (
  String[1] $package_name,
  Stdlib::Absolutepath $config_dir,
  Stdlib::Absolutepath $var_dir,
  Stdlib::Absolutepath $cache_dir = '/var/cache/syslog-ng',
  Boolean $manage_package = true,
  Array[String[1]] $syslogng_modules = [],
  Boolean $use_hiera = false,
  Boolean $test_before_deploy = true
) {
# package
  if $manage_package {
    ensure_resource ( 'package', $package_name, { 'ensure' => 'installed' })
  }
  ensure_resource ( 'file', $cache_dir, { ensure => directory })
  ensure_resource (
    'file', $var_dir,
    { ensure => 'directory' }
  )
  file { "${var_dir}/patterndb":
    ensure  => 'directory',
    purge   => true,
    recurse => true,
  }

  file { $config_dir:
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
    source  => 'puppet:///modules/patterndb/patterndb.d',
  }

  if $use_hiera {
    include patterndb::hiera
  }
}
