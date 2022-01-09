## [v3.0.0](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v3.0.0) (2018-03-22)

* new major release
* drop support for puppet < 4.9.0

## [v2.3.0-beta1](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v2.3.0-beta1) (2017-06-07)

* add support for polling hiera

## [v2.2.2](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v2.2.2) (2015-08-26)

* fix bug in htmlentities that fracked up pdbs iunder ruby 2.1

## [v2.2.1](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v2.2.1) (2015-08-26)

* context_timeout now accepts Fixnum as well as String
* add parameter order for ruleset
* Drop support for puppet 2.x
* minor author fixes

## [v2.2.0](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v2.2.0) (2015-08-26)

UNRELEASED

## [v2.1.1](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v2.1.1) (2015-08-26)

UNRELEASED

* escape special chars in generated xml
* Allow empty patterns in rulesets
* context_timeout and version now accept Fixnum as well as String

## [v2.1.0](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v2.1.0) (2014-08-12)

Separate Rulesets, Rules and Actions

* rules accept the `order` parameter which controls the order
  of appearance in the merged parser file
* rulesets, rules and actions can now be declared separately
  this pulls in the puppetlabs-concat dependancy
* allow rules and patterns to be strings
  that will be coerced to single-element arrays
  this will make it easier to use this module with puppetdb
  https://tickets.puppetlabs.com/browse/PDB-170
* treat action/message/inherit_properties as a real boolean

## [v2.0.0](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v2.0.0) (2014-06-16)

Support multiple merged patterndb files

* added support for multiple pattern databases
* class `patterndb::update` replaced by define `patterndb::parser`
* moved parameters from `update` to base class

## [v1.0.0](https://github.com/ccin2p3/puppet-patterndb/releases/tag/v1.0.0) (2014-06-10)

Initial release
