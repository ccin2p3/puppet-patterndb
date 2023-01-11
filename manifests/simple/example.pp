# default values are being ignored for now
define patterndb::simple::example (
  String[1] $program,
  String[1] $test_message,
  Hash[
    String[1],
    Struct[
      {
        type  => Optional[Enum['datetime', 'double', 'integer', 'json', 'string']],
        value => String[1],
      }
    ]
  ] $test_values = {},
) {
}
