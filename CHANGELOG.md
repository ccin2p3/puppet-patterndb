# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v5.0.0](https://github.com/ccin2p3/puppet-patterndb/tree/v5.0.0) (2023-02-07)

[Full Changelog](https://github.com/ccin2p3/puppet-patterndb/compare/v4.0.1...v5.0.0)

**Breaking changes:**

- Add data types everywhere and do not allow values where arrays are expected [\#31](https://github.com/ccin2p3/puppet-patterndb/pull/31) ([smortex](https://github.com/smortex))
- Add support for patterndb v6 type-hints [\#30](https://github.com/ccin2p3/puppet-patterndb/pull/30) ([smortex](https://github.com/smortex))
- Drop support of CentOS 6 / RedHat 6 \(EOL\) [\#24](https://github.com/ccin2p3/puppet-patterndb/pull/24) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Manage patterndb version in generated XML files [\#33](https://github.com/ccin2p3/puppet-patterndb/pull/33) ([faxm0dem](https://github.com/faxm0dem))
- Add support for AlmaLinux [\#27](https://github.com/ccin2p3/puppet-patterndb/pull/27) ([smortex](https://github.com/smortex))
- Add support for Rocky [\#26](https://github.com/ccin2p3/puppet-patterndb/pull/26) ([smortex](https://github.com/smortex))
- Add support for Ubuntu [\#25](https://github.com/ccin2p3/puppet-patterndb/pull/25) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix dependencies version bounds [\#29](https://github.com/ccin2p3/puppet-patterndb/pull/29) ([smortex](https://github.com/smortex))

**Closed issues:**

- Bring back smoke tests ! [\#22](https://github.com/ccin2p3/puppet-patterndb/issues/22)

**Merged pull requests:**

- Run acceptance tests [\#21](https://github.com/ccin2p3/puppet-patterndb/pull/21) ([smortex](https://github.com/smortex))

## [v4.0.1](https://github.com/ccin2p3/puppet-patterndb/tree/v4.0.1) (2022-02-23)

[Full Changelog](https://github.com/ccin2p3/puppet-patterndb/compare/v4.0.0...v4.0.1)

**Fixed bugs:**

- Fix variable interpolation [\#20](https://github.com/ccin2p3/puppet-patterndb/pull/20) ([smortex](https://github.com/smortex))

## [v4.0.0](https://github.com/ccin2p3/puppet-patterndb/tree/v4.0.0) (2022-02-04)

[Full Changelog](https://github.com/ccin2p3/puppet-patterndb/compare/v3.0.0...v4.0.0)

**Breaking changes:**

- Drop support for Puppet 4 and 5 \(EOL\) [\#18](https://github.com/ccin2p3/puppet-patterndb/pull/18) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Allow up-to-date dependencies [\#16](https://github.com/ccin2p3/puppet-patterndb/pull/16) ([smortex](https://github.com/smortex))
- Add support for Puppet 6 & 7 [\#15](https://github.com/ccin2p3/puppet-patterndb/pull/15) ([smortex](https://github.com/smortex))
- Add support for Debian 11 [\#13](https://github.com/ccin2p3/puppet-patterndb/pull/13) ([smortex](https://github.com/smortex))
- Ensure syslog-ng-core is installed on Debian [\#6](https://github.com/ccin2p3/puppet-patterndb/pull/6) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix test suite [\#8](https://github.com/ccin2p3/puppet-patterndb/pull/8) ([smortex](https://github.com/smortex))
- Fix typos in README [\#5](https://github.com/ccin2p3/puppet-patterndb/pull/5) ([smortex](https://github.com/smortex))

**Closed issues:**

- Module broken with Puppet 5.5.7 [\#7](https://github.com/ccin2p3/puppet-patterndb/issues/7)

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
