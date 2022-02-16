if fact('os.family') == 'Debian' {
  # FIXME: https://github.com/puppetlabs/puppetlabs-apt/pull/1015
  ensure_packages('apt-transport-https')
  Package['apt-transport-https'] -> Class['apt::update']
}
if fact('os.family') == 'RedHat' {
  class { 'epel':
  }
  Class['epel'] -> Class['syslog_ng']
}

class { 'syslog_ng':
  manage_repo => true,
}

syslog_ng::config { 'version':
  content => '@version: 3.30',
  order   => '02',
}

if fact('os.family') == 'Debian' {
  syslog_ng::module { 'getent':
  }
}
