type Patterndb::Rule = Struct[
  {
    patterns        => Array[String[1]],
    id              => String[1],
    provider        => Optional[String[1]],
    ruleclass       => Optional[String[1]],
    context_id      => Optional[String[1]],
    context_timeout => Optional[Integer],
    context_scope   => Optional[String[1]],
    order           => Optional[String[1]],
    actions         => Optional[Array],
    urls            => Optional[Array],
    examples        => Optional[Array[Patterndb::Example]],
    tags            => Optional[Array],
    values          => Optional[Hash],
  },
]
