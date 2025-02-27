# frozen_string_literal: true

require 'spec_helper'

describe 'patterndb::raw::ruleset' do
  on_supported_os.each do |os, facts|
    context "#{os} without package_name" do
      let :facts do
        facts
      end

      let :title do
        'myrawruleset'
      end
      let :pre_condition do
        'class { "patterndb": }'
      end

      context 'Raw ruleset with no params' do
        let :params do
          {}
        end

        it { expect { is_expected.to compile }.to raise_error(%r{source}m) }
      end

      context 'Raw ruleset with only source' do
        let :params do
          {
            source: 'BLAH',
          }
        end

        case facts[:osfamily]
        when 'FreeBSD'
          it { is_expected.to contain_file('/usr/local/etc/patterndb.d/default/myrawruleset.pdb') }
        else
          it { is_expected.to contain_file('/etc/syslog-ng/patterndb.d/default/myrawruleset.pdb') }
        end
      end

      context 'Raw rulesets with directory' do
        let :params do
          {
            source: 'BLAH.D',
            ensure: 'directory',
          }
        end

        case facts[:osfamily]
        when 'FreeBSD'
          it { is_expected.to contain_file('/usr/local/etc/patterndb.d/default/myrawruleset').with(ensure: 'directory') }
        else
          it { is_expected.to contain_file('/etc/syslog-ng/patterndb.d/default/myrawruleset').with(ensure: 'directory') }
        end
      end
    end
  end
end
