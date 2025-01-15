#
class { 'patterndb':
  manage_package   => false,
  syslogng_modules => [],
}

Patterndb::Simple::Rule {
  provider => 'blah',
}

patterndb::simple::ruleset { 'a':
  id       => 'a',
  patterns => ['a'],
  pubdate  => '1985-01-01',
  rules    => [
    {
      id        => 'b',
      patterns  => ['ma<>tch @ESTRING:this: @dude'],
      ruleclass => 'b',
      values    => {
        'foo' => 1,
        'bar' => 4,
      },
      examples  => [
        {
          program      => 'a',
          test_message => 'ma<>tch me dude',
          test_values  => {
            'this' => {
              value => 'me',
            },
          },
        },
      ],
    },
  ],
}

create_resources('patterndb::simple::ruleset', lookup('patterndb::simple::ruleset', undef, undef, {}))
create_resources('patterndb::simple::rule', lookup('patterndb::simple::rule', undef, undef, {}))
#create_resources('patterndb::simple::action', lookup('patterndb::simple::action', undef, undef, {}))
