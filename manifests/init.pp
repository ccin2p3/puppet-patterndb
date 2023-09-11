#
class patterndb (
  String[1] $package_name,
  Stdlib::Absolutepath $config_dir,
  String[1] $base_dir = '/',
  String[1] $temp_dir = "${base_dir}/tmp/syslog-ng",
  Boolean $manage_package = true,
  Array[String[1]] $syslogng_modules = [],
  Boolean $use_hiera = false,
  Boolean $_manage_top_dirs = true,
  Boolean $test_before_deploy = true
) {
# package
  if $manage_package {
    ensure_resource ( 'package', $package_name, { 'ensure' => 'installed' })
  }
  ensure_resource ( 'file', $temp_dir, { ensure => directory })
  if $_manage_top_dirs {
    ensure_resource ( 'file', "${base_dir}/etc", { ensure => 'directory' })
    ensure_resource ( 'file', "${base_dir}/var", { ensure => 'directory' })
    ensure_resource ( 'file', "${base_dir}/var/lib", { ensure => 'directory' })
  }
  ensure_resource (
    'file', "${base_dir}/etc/syslog-ng",
    { ensure => 'directory' }
  )
  ensure_resource (
    'file', "${base_dir}/var/lib/syslog-ng",
    { ensure => 'directory' }
  )
  ensure_resource (
    'file', "${base_dir}/var/lib/syslog-ng/patterndb",
    {
      ensure => 'directory',
      purge => true,
      recurse => true
    }
  )
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
