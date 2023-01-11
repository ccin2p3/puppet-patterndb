# default values are being ignored for now
define patterndb::simple::rule (
  Array[String[1]] $patterns,
  String[1] $ruleset,
  String[1] $id = $title,
  String[1] $provider = 'puppet',
  String[1] $ruleclass = 'system',
  Optional[String[1]] $context_id = undef,
  Boolean $_embedded = false,
  Optional[Integer] $context_timeout = undef,
  Optional[String[1]] $context_scope = undef,
  String[1] $order = '00',
  Array $actions = [],
# begin currently ignored
  Array $urls = [],
# end currently ignored
  Array[Patterndb::Example] $examples = [],
  Array $tags = [],
  Hash $values = {},
) {
  $patterns_sanitized = htmlentities($patterns)

  # validate sample messages
  if (! $_embedded) { # we were defined outside the ruleset
    if (! defined(Patterndb::Simple::Ruleset[$ruleset])) {
      fail("Failed while trying to define rule `${title}` for undeclared ruleset `${ruleset}`")
    }
  }
  # header
  concat::fragment { "patterndb_simple_rule-${title}-header":
    target  => "patterndb_simple_ruleset-${ruleset}",
    content => template('patterndb/rule-header.erb'),
    order   => "002-${order}-${title}-001",
  }
  # import embedded actions
  patterndb_simple_action ( $actions, $id, $order )
  # footer
  concat::fragment { "patterndb_simple_rule-${title}-footer":
    target  => "patterndb_simple_ruleset-${ruleset}",
    content => template('patterndb/rule-footer.erb'),
    order   => "002-${order}-${title}-zzz",
  }
}
