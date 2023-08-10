# frozen_string_literal: true

require 'spec_helper'

describe 'patterndb::parser', type: 'define' do
  on_supported_os.each do |os, facts|
    context "#{os} without package_name" do
      let :facts do
        facts
      end

      let :title do
        'default'
      end
      let(:pre_condition) { 'include patterndb' }

      context 'Catchall' do
        it { is_expected.to contain_class('Patterndb') }
        it { is_expected.to contain_exec('patterndb::merge::default') }
      end

      context 'Default values (no parameters)' do
        let :params do
          {
            # noparams
          }
        end

        it {
          is_expected.to contain_exec('patterndb::deploy::default').with(
            'command' => 'pdbtool test /tmp/syslog-ng/patterndb/default.xml  && cp /tmp/syslog-ng/patterndb/default.xml //var/lib/syslog-ng/patterndb/default.xml'
          )
        }
      end

      context 'With optional syslog-ng module' do
        let :params do
          {
            syslogng_modules: %w[foo bar],
          }
        end

        it {
          is_expected.to contain_exec('patterndb::deploy::default').with(
            'command' => 'pdbtool test /tmp/syslog-ng/patterndb/default.xml --module=foo --module=bar && cp /tmp/syslog-ng/patterndb/default.xml //var/lib/syslog-ng/patterndb/default.xml'
          )
        }
      end

      context 'with two patterndbs' do
        let :pre_condition do
          'patterndb::parser { "stage1": }'
        end

        it {
          is_expected.to contain_exec('patterndb::deploy::default').with(
            'command' => 'pdbtool test /tmp/syslog-ng/patterndb/default.xml  && cp /tmp/syslog-ng/patterndb/default.xml //var/lib/syslog-ng/patterndb/default.xml'
          )
        }

        it {
          is_expected.to contain_exec('patterndb::deploy::stage1').with(
            'command' => 'pdbtool test /tmp/syslog-ng/patterndb/stage1.xml  && cp /tmp/syslog-ng/patterndb/stage1.xml //var/lib/syslog-ng/patterndb/stage1.xml'
          )
        }
      end

      context 'With syslog-ng module in class' do
        let :pre_condition do
          ['class { "patterndb": syslogng_modules => [ "foo","bar"] }',
           'Patterndb::Parser { syslogng_modules => [ "foo","bar"] }']
        end

        it {
          is_expected.to contain_exec('patterndb::deploy::default').with(
            'command' => 'pdbtool test /tmp/syslog-ng/patterndb/default.xml --module=foo --module=bar && cp /tmp/syslog-ng/patterndb/default.xml //var/lib/syslog-ng/patterndb/default.xml'
          )
        }
      end

      context 'With empty syslog-ng module list' do
        let :pre_condition do
          'class { "patterndb": syslogng_modules => [] }'
        end

        it {
          is_expected.to contain_exec('patterndb::deploy::default').with(
            'command' => 'pdbtool test /tmp/syslog-ng/patterndb/default.xml  && cp /tmp/syslog-ng/patterndb/default.xml //var/lib/syslog-ng/patterndb/default.xml'
          )
        }
      end

      context 'Without deploy' do
        let :params do
          {
            test_before_deploy: false,
          }
        end

        it { is_expected.to contain_exec('patterndb::deploy::default').with(command: 'cp /tmp/syslog-ng/patterndb/default.xml //var/lib/syslog-ng/patterndb/default.xml') }
      end

      context 'With test_before_deploy' do
        let :params do
          {
            test_before_deploy: true,
          }
        end

        it { is_expected.to contain_exec('patterndb::deploy::default').with(command: 'pdbtool test /tmp/syslog-ng/patterndb/default.xml  && cp /tmp/syslog-ng/patterndb/default.xml //var/lib/syslog-ng/patterndb/default.xml') }
      end
    end
  end
end
