type Patterndb::Example = Struct[
  {
    program      => String,
    test_message => String[1],
    test_values  => Optional[
      Hash[
        String[1],
        Struct[
          {
            Optional['type'] => Enum['datetime', 'double', 'integer', 'json', 'string', 'null'],
            value => Variant[String,Numeric]
          }
        ],
      ],
    ],
  },
]
