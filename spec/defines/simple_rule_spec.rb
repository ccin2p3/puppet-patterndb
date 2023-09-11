# frozen_string_literal: true

require 'spec_helper'

describe 'patterndb::simple::rule' do
  on_supported_os.each do |os, facts|
    context "#{os} without package_name" do
      let :facts do
        facts
      end

      let :title do
        'myrule'
      end
      let :default_params do
        {
          id: 'RULE_ID',
        }
      end
      let :pre_condition do
        'class { "patterndb": base_dir => "/BASEDIR", }
        patterndb::simple::ruleset { "myruleset":
          id => "RULESET_ID",
          pubdate => "1970-01-01",
          patterns => [ "a", "b" ]
        }
        Exec { path => ["/bin","/usr/bin"] }'
      end

      context 'Simple invalid rule with no patterns' do
        let :params do
          default_params.merge(
            ruleset: 'myruleset'
          )
        end

        it { expect { is_expected.to compile }.to raise_error(%r{patterns}m) }
      end

      context 'Simple invalid rule with no ruleset' do
        let :params do
          default_params.merge(
            patterns: ["Ford... you're turning into a penguin. Stop it."]
          )
        end

        it { expect { is_expected.to compile }.to raise_error(%r{ruleset}m) }
      end

      context 'Simple invalid rule with inexisting ruleset' do
        let :params do
          default_params.merge(
            patterns: ["Ford... you're turning into a penguin. Stop it."],
            ruleset: 'this_ruleset_was_not_predeclared'
          )
        end

        it { expect { is_expected.to compile }.to raise_error(%r{Failed while trying to define rule.*for undeclared ruleset}m) }
      end

      context 'Simple rule with 1 string pattern and ruleset' do
        let :params do
          default_params.merge(
            patterns: ['Time is an illusion. Lunchtime doubly so.'],
            ruleset: 'myruleset'
          )
        end

        it {
          is_expected.to contain_patterndb__simple__ruleset('myruleset')
          is_expected.to contain_patterndb__simple__rule('myrule').with(
            ruleset: 'myruleset',
            patterns: ['Time is an illusion. Lunchtime doubly so.']
          )
        }

        case facts[:osfamily]
        when 'FreeBSD'
          it {
            is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').with(
              path: '/BASEDIR/usr/local/etc/patterndb.d/default/myruleset.pdb'
            )
          }
        else
          it {
            is_expected.to contain_concat('patterndb_simple_ruleset-myruleset').with(
              path: '/BASEDIR/etc/syslog-ng/patterndb.d/default/myruleset.pdb'
            )
          }
        end
        it {
          is_expected.to contain_concat__fragment('patterndb_simple_rule-myrule-header').with(
            target: 'patterndb_simple_ruleset-myruleset'
          ).with_content(
            %r{<patterns>\s*<pattern>Time is an illusion. Lunchtime doubly so.</pattern>\s*</patterns>}m
          )
        }
      end
    end
  end
end
