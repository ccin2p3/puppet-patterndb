type Patterndb::Example = Struct[
  {
    program      => String[1],
    test_message => String[1],
    test_values  => Hash[
      String[1],
      Struct[
        {
          type  => Optional[Enum['datetime', 'double', 'integer', 'json', 'string']],
          value => String[1],
        }
      ],
    ],
  },
]
