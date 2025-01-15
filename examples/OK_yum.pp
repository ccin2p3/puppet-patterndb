#
class { 'patterndb':
  manage_package     => false,
  syslogng_modules   => [],
  test_before_deploy => true,
}

patterndb::simple::ruleset { 'yum':
  id       => 'f2ff6bd5-749e-4c56-bbae-fcc3edc19897',
  patterns => ['yum', 'yum-initupdate'],
  pubdate  => '2014-04-03',
  rules    => [
    {
      id       => '0c579629-0359-4e17-af30-19cfc3bf2ef8',
      patterns => [
        # lint:ignore:140chars
# for package versions numbers and other characterse.g. my-best-app-4-2.noarch
        'Installed: @PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Installed: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
# for package versions with only numbers e.g. my-best-app-4-2.noarch
        'Installed: @PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Installed: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        # lint:endignore
#
      ],
      tags     => ['appacct'],
      values   => {
# the following removes the trailing dash
        'appacct.rsname' => '$(substr "${tmp.package_name}" "0" "-1")', # lint:ignore:single_quote_string_with_variables
#
        'appacct.rstype' => 'install',
      },
      examples => [
        {
          program      => 'yum',
          test_message => 'Installed: 4:perl-Time-HiRes-1.9721-136.el6.x86_64',
          test_values  => {
            'appacct.rsname'  => {
              value => 'perl-Time-HiRes',
            },
            'appacct.epoch'   => {
              value => '4',
            },
            'appacct.version' => {
              value => '1.9721',
            },
            'appacct.release' => {
              value => '136.el6',
            },
            'appacct.arch'    => {
              value => 'x86_64',
            },
            'appacct.rstype'  => {
              value => 'install',
            },
          },
        },
        {
          program      => 'yum',
          test_message => 'Installed: token-forge-2-1.x86_64',
          test_values  => {
            'appacct.rsname'  => {
              value => 'token-forge',
            },
            'appacct.version' => {
              value => '2',
            },
            'appacct.release' => {
              value => '1',
            },
            'appacct.arch'    => {
              value => 'x86_64',
            },
            'appacct.rstype'  => {
              value => 'install',
            },
          },
        },
        {
          program      => 'yum',
          test_message => 'Installed: perl-Class-MakeMethods-1.01-5.el6.noarch',
          test_values  => {
            'appacct.rsname'  => {
              value => 'perl-Class-MakeMethods',
            },
            'appacct.version' => {
              value => '1.01',
            },
            'appacct.release' => {
              value => '5.el6',
            },
            'appacct.arch'    => {
              value => 'noarch',
            },
            'appacct.rstype'  => {
              value => 'install',
            },
          },
        },
      ],
    },
    {
      id       => '347533ea-c8ab-41b3-a343-6d9204cc7680',
      patterns => [
# for package versions numbers and other characterse.g. my-best-app-4-2.noarch
        # lint:ignore:140chars
        'Updated: @PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Updated: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
# for package versions with only numbers e.g. my-best-app-4-2.noarch
        'Updated: @PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Updated: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        # lint:endignore
#
      ],
      tags     => ['appacct'],
      values   => {
        'appacct.rsname' => '$(substr "${tmp.package_name}" "0" "-1")', # lint:ignore:single_quote_string_with_variables
        'appacct.rstype' => 'update',
      },
      examples => [
        {
          program      => 'yum',
          test_message => 'Updated: python-boto-2.25.0-2.el6.noarch',
          test_values  => {
            'appacct.rsname'  => {
              value => 'python-boto',
            },
            'appacct.version' => {
              value => '2.25.0',
            },
            'appacct.release' => {
              value => '2.el6',
            },
            'appacct.arch'    => {
              value => 'noarch',
            },
            'appacct.rstype'  => {
              value => 'update',
            },
          },
        },
      ],
    },
    {
      id       => '73b7803c-9e1f-4f1a-afa6-8eb7a6725f3a',
      patterns => [
        'Erased: @ANYSTRING:appacct.rsname@',
      ],
      tags     => ['appacct'],
      values   => {
        'appacct.rstype' => 'erase',
      },
      examples => [
        {
          program      => 'yum',
          test_message => 'Erased: nagios-plugins-ups',
          test_values  => {
            'appacct.rsname' => {
              value => 'nagios-plugins-ups',
            },
            'appacct.rstype' => {
              value => 'erase',
            },
          },
        },
      ]
    }
  ],
}
