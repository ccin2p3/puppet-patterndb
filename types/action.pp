type Patterndb::Action = Struct[
  {
    trigger   => Optional[String[1]],
    rate      => Optional[String[1]],
    condition => Optional[String[1]],
    message   => Struct[
      {
        inherit_properties => Optional[Boolean],
        tags               => Optional[Array[String[1]]],
        values             => Optional[Hash[String[1], String]],
      },
    ],
  },
]
