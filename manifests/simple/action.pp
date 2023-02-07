# default values are being ignored for now
define patterndb::simple::action (
  String[1] $rule,
  Hash $message,
  Optional[Enum['match', 'timeout']] $trigger = undef,
  Optional[String[1]] $rate = undef,
  Optional[String[1]] $condition = undef,
  Boolean $_embedded = false,
  String[1] $rule_order = '00',
) {
  if (! $_embedded) { # we were defined outside the rule
    if (! defined(Patterndb::Simple::Rule[$rule])) {
      fail("Failed while trying to define action `${title}` for undeclared rule `${rule}`")
    }
  }
  $ruleset = getparam("Patterndb::Simple::Rule[${rule}]",'ruleset')
  concat::fragment { "patterndb_simple_rule-${rule}-${title}":
    target  => "patterndb_simple_ruleset-${ruleset}",
    content => template('patterndb/action.erb'),
    order   => "002-${rule_order}-${rule}-002",
  }
}
