type Patterndb::Rule = Struct[
  {
    patterns                  => Array[String[1]],
    Optional[id]              => String[1],
    Optional[provider]        => String[1],
    Optional[ruleclass]       => String[1],
    Optional[context_id]      => String[1],
    Optional[context_timeout] => Integer,
    Optional[context_scope]   => Patterndb::Context_scope,
    Optional[order]           => String[1],
    Optional[actions]         => Array[Patterndb::Action],
    Optional[urls]            => Array,
    Optional[examples]        => Array[Patterndb::Example],
    Optional[tags]            => Array,
    Optional[values]          => Hash,
  },
]
