# frozen_string_literal: true

require 'spec_helper'

describe 'patterndb::simple::ruleset' do
  on_supported_os.each do |os, facts|
    context "#{os} without package_name" do
      let :facts do
        facts
      end

      let :title do
        'myruleset'
      end
      let :default_params do
        {
          id: 'ID',
          pubdate: '1970-01-01',
          version: '4',
        }
      end
      let :pre_condition do
        'class { "patterndb": base_dir => "/BASEDIR", }
        Exec { path => ["/bin","/usr/bin"] }'
      end

      context 'Simple ruleset without patterns' do
        let :params do
          default_params.merge(
            rules: {}
          )
        end

        it {
          is_expected.to contain_patterndb__simple__ruleset('myruleset').with(
            parser: 'default'
          )
        }
      end

      context 'Simple ruleset with wrong type for rules' do
        let :params do
          default_params.merge(
            patterns: ['P'],
            rules: 'invalid_type_is_string'
          )
        end

        it { expect { is_expected.to compile }.to raise_error(%r{is neither a hash nor an array}m) }
      end

      context 'Simple ruleset with wrong type for patterns' do
        let :params do
          default_params.merge(
            patterns: { 'P' => 'V' },
            rules: {}
          )
        end

        it { expect { is_expected.to compile }.to raise_error(%r{is neither a string nor an array}m) }
      end

      context 'Simple ruleset with illegal embedded rule definition (no id)' do
        let :params do
          default_params.merge(
            patterns: ['P1'],
            rules: {
              'patterns' => ['this is a pattern'],
            }
          )
        end

        it { expect { is_expected.to compile }.to raise_error(%r{Failed to create embedded rule for ruleset.*no 'id' provided}m) }
      end

      context 'Simple ruleset with hash type for rules' do
        let :params do
          default_params.merge(
            patterns: ['P1'],
            rules: {
              'id' => 'RULE_1_ID',
              'patterns' => [],
            }
          )
        end

        it {
          is_expected.to contain_patterndb__simple__ruleset('myruleset').with(
            parser: 'default'
          )
        }

        it { is_expected.to contain_patterndb__parser('default') }

        it {
          is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').with('path' => '/BASEDIR/etc/syslog-ng/patterndb.d/default/myruleset.pdb')
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-header').with_content(
            %r{<patterns>.*<pattern>P1</pattern>.*</patterns>}m
          )
        }

        it { is_expected.to contain_patterndb__simple__rule('RULE_1_ID') }
      end

      context 'Simple ruleset with string type for patterns' do
        let :params do
          default_params.merge(
            patterns: 'P1',
            rules: []
          )
        end

        it { is_expected.to contain_patterndb__parser('default') }

        it {
          is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').with('path' => '/BASEDIR/etc/syslog-ng/patterndb.d/default/myruleset.pdb')
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-header').with_content(
            %r{<patterns>.*<pattern>P1</pattern>.*</patterns>}m
          )
        }
      end

      context 'Simple ruleset with invalid string type for rules' do
        let :params do
          default_params.merge(
            patterns: %w[P1 P2],
            rules: 'invalid_string_rule'
          )
        end

        it { expect { is_expected.to compile }.to raise_error(%r{is neither a hash nor an array}m) }
      end

      context 'Simple ruleset with empty rules and patterns' do
        let :params do
          default_params.merge(
            patterns: [],
            rules: []
          )
        end

        it { is_expected.to contain_patterndb__parser('default') }

        it {
          is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').with('path' => '/BASEDIR/etc/syslog-ng/patterndb.d/default/myruleset.pdb')
          is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').that_notifies(
            'Exec[patterndb::merge::default]'
          )
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-header').with_content(
            %r{<patterndb}m
          ).with_content(
            %r{name='myruleset'}m
          ).with_content(
            %r{id='ID'}m
          ).with_content(
            %r{pub_date='1970-01-01'}m
          )
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-footer').with_content(
            %r{</patterndb>}m
          )
        }

        it {
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-header').with_content(
            %r{<description>generated by puppet</description>}m
          )
        }

        it {
          is_expected.not_to contain__fragment('patterndb_simple_ruleset-myruleset-header').with_content(
            %r{url='}m
          )
        }
      end

      context 'Simple ruleset with description, url and custom patterndb name' do
        let :params do
          default_params.merge(
            patterns: ['P1'],
            url: 'URL',
            description: 'DESCRIPTION',
            parser: 'PARSER',
            rules: [
              {
                'id' => 'RULE_1_ID',
                'patterns' => [],
              },
            ]
          )
        end

        it {
          is_expected.to contain_patterndb__simple__ruleset('myruleset').with(
            parser: 'PARSER'
          )
        }

        it { is_expected.not_to contain_patterndb__parser('default') }
        it { is_expected.to contain_patterndb__parser('PARSER') }
        it { is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').with('path' => '/BASEDIR/etc/syslog-ng/patterndb.d/PARSER/myruleset.pdb') }

        it {
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-header').with(
            'target' => 'patterndb_simple_ruleset-myruleset'
          )
        }

        it {
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-header').with_content(
            %r{<description>DESCRIPTION</description>}m
          ).with_content(
            %r{<url>URL</url>}m
          )
        }
      end

      context 'Simple ruleset with one rule and 2 examples' do
        let :params do
          default_params.merge(
            patterns: %w[P1 P2],
            rules: [
              {
                'id' => 'RULE_1_ID',
                'patterns' => [
                  'Simple ruleset with @ESTRING:num_rules: @rule and @NUMBER:num_examples@ example',
                  'Simple ruleset with @ESTRING:num_rules: @rules and @NUMBER:num_examples@ examples',
                  'Simple ruleset with @ESTRING:num_rules: @rule and @NUMBER:num_examples@ examples',
                  'Simple ruleset with @ESTRING:num_rules: @rules and @NUMBER:num_examples@ example',
                ],
                'examples' => [
                  {
                    'test_message' => 'Simple ruleset with 2 rules and 1 example',
                    'program' => 'P1',
                    'test_values' => {
                      'num_examples' => '1',
                      'num_rules' => '2',
                    },
                  },
                ],
              }, {
                'id' => 'RULE_2_ID',
                'patterns' => [
                  'This is a @ESTRING:type: @rule',
                ],
                'examples' => [
                  {
                    'test_message' => 'This is a simple rule',
                    'program' => 'P2',
                    'test_values' => {
                      'type' => 'simple',
                    },
                  },
                  {
                    'test_message' => 'This is a complicated rule',
                    'program' => 'P2',
                    'test_values' => {
                      'type' => 'complicated',
                    },
                  },
                ],
              }
            ]
          )
        end

        # it {
        #  pp subject.resources
        # }
        it { is_expected.to contain_patterndb__simple__example('RULE_1_ID-0') }
        it { is_expected.not_to contain_patterndb__simple__example('RULE_1_ID-1') }
        it { is_expected.to contain_patterndb__simple__example('RULE_2_ID-0') }
        it { is_expected.to contain_patterndb__simple__example('RULE_2_ID-1') }
      end

      context 'Simple ruleset with one rule, correlation and action' do
        let :params do
          default_params.merge(
            patterns: ['foo'],
            rules: [
              {
                'id' => 'RULE_ID',
                'patterns' => ['this is a log message where @ESTRING:key:=@@ANYSTRING:value@'],
                'provider' => 'PROVIDER',
                'ruleclass' => 'RULECLASS',
                'values' => { 'KEY_FOO' => 'VAL_FOO', 'KEY_BAZ' => 'VAL_BAZ' },
                'tags' => %w[TAG_FOO TAG_BAR],
                'context_id' => 'CTX_FOO',
                'context_timeout' => 42,
                'context_scope' => 'global',
                'actions' => [
                  {
                    'trigger' => 'timeout',
                    'rate' => '1/60',
                    'condition' => '"2" > "1"',
                    'message' => {
                      'inherit_properties' => true,
                      'values' => {
                        'MESSAGE' => 'MESSAGE_ACTION',
                      },
                      'tags' => ['TAG_ACTION'],
                    },
                  },
                ],
              },
            ]
          )
        end

        it {
          is_expected.to contain_concat__fragment('patterndb_simple_rule-RULE_ID-header').with_content(
            %r{<pattern>this is a log message where @ESTRING:key:=@@ANYSTRING:value@}m
          ).with_content(
            %r{provider='PROVIDER'}m
          ).with_content(
            %r{class='RULECLASS'}m
          ).with_content(
            %r{<value name='KEY_FOO'>VAL_FOO</value>}
          ).with_content(
            %r{<value name='KEY_BAZ'>VAL_BAZ</value>}
          ).with_content(
            %r{<tag>TAG_FOO</tag>}
          ).with_content(
            %r{<tag>TAG_BAR</tag>}
          ).with_content(
            %r{context-id='CTX_FOO'}
          ).with_content(
            %r{context-scope='global'}
          ).with_content(
            %r{context-timeout='42'}
          ).with_content(
            %r{<actions>}
          )
          is_expected.to contain_concat__fragment('patterndb_simple_rule-RULE_ID-RULE_ID-0').with_content(
            %r{<action.*trigger='timeout'.*</action>}m
          ).with_content(
            %r{<action.*rate='1/60'.*</action>}m
          ).with_content(
            %r{<action.*condition='"2" > "1"'.*</action>}m
          )
        }

        it {
          is_expected.to contain_concat__fragment('patterndb_simple_rule-RULE_ID-RULE_ID-0').with_content(
            %r{<action.*>.*<message .*inherit-properties='TRUE'.*>.*<values>.*<value name='MESSAGE'>.*MESSAGE_ACTION.*</value>.*</values>.*</action>}m
          ).with_content(
            %r{<action.*>.*<message .*inherit-properties='TRUE'.*>.*<tags>.*<tag>.*TAG_ACTION.*</tag>.*</tags>.*</action>}m
          )
        }

        it { is_expected.to contain_patterndb__simple__action('RULE_ID-0') }
        it { is_expected.to contain_patterndb__simple__action__message('RULE_ID-0') }
      end

      context 'Simple ruleset with order' do
        let :params do
          default_params.merge(
            patterns: 'P1',
            order: '123',
            rules: []
          )
        end

        it { is_expected.to contain_patterndb__parser('default') }

        it {
          is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').with('path' => '/BASEDIR/etc/syslog-ng/patterndb.d/default/123myruleset.pdb')
          is_expected.to contain_concat__fragment('patterndb_simple_ruleset-myruleset-header').with_content(
            %r{<patterns>.*<pattern>P1</pattern>.*</patterns>}m
          )
        }
      end
    end
  end
end
