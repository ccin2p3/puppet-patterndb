#
class patterndb::hiera (
  $prefix = 'patterndb'
) {
  create_resources(
    'patterndb::parser',
    lookup("${prefix}::parser", default_value => {})
  )
  create_resources(
    'patterndb::simple::ruleset',
    lookup("${prefix}::ruleset", default_value => {})
  )
  create_resources(
    'patterndb::simple::rule',
    lookup("${prefix}::rule", default_value => {})
  )
  create_resources(
    'patterndb::simple::action',
    lookup("${prefix}::action", default_value => {})
  )
}
