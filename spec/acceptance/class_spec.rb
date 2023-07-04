# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'patterndb class' do
  before(:all) do
    shell('puppet module install ccin2p3/syslog_ng')
    shell('puppet module install puppetlabs/apt')
    shell('puppet module install puppet/epel')
  end

  # Setup requirements
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
        if fact('os.family') == 'RedHat' {
          class { 'epel':
          }
          Class['epel'] -> Class['syslog_ng']
        }

        class { 'syslog_ng':
          manage_repo => true,
        }

        syslog_ng::config { 'version':
          content => '@version: 3.30',
          order   => '02',
        }

        if fact('os.family') == 'Debian' {
          syslog_ng::module { 'getent':
          }
        }
      PUPPET
    end
  end

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'patterndb':
        manage_package => false,
      }

      patterndb::simple::ruleset { 'puppetserver':
        id       => '7fc67fd9-ef16-4fce-808a-632cf7cc95bd',
        patterns => [
          'puppetserver',
        ],
        pubdate  => '2021-02-03',
        rules    => [
          {
            id       => '491b346f-4f02-475e-95e8-cb691f305286',
            patterns => [
              '@ESTRING:.puppetserver.timestamp: @@STRING:.puppetserver.severity@ @QSTRING:.puppetserver.thread_name:[]@ @QSTRING:puppetserver.category:[]@ @ANYSTRING:puppetserver.message@',
              '@ESTRING:.puppetserver.timestamp: @@STRING:.puppetserver.severity@  @QSTRING:.puppetserver.thread_name:[]@ @QSTRING:puppetserver.category:[]@ @ANYSTRING:puppetserver.message@',
            ],
            examples => [
              {
                program      => 'puppetserver',
                test_message => '2021-02-04T13:23:36.354-05:00 ERROR [qtp1102047314-254822] [puppetserver] Puppet Evaluation Error: Error while evaluating a Function Call, Could not find class ::mcollective_agent_bolt_tasks for vps238244.vittoria.pro (file: /etc/puppetlabs/code/environments/production/modules/mcollective/manifests/init.pp, line: 77, column: 3) on node vps238244.vittoria.pro',
                test_values  => {
                  '.puppetserver.severity'    => {
                    value => 'ERROR',
                  },
                  '.puppetserver.thread_name' => {
                    value => 'qtp1102047314-254822',
                  },
                  '.puppetserver.timestamp'   => {
                    value => '2021-02-04T13:23:36.354-05:00',
                  },
                  'puppetserver.category'     => {
                    value => 'puppetserver',
                  },
                  'puppetserver.message'      => {
                    value => 'Puppet Evaluation Error: Error while evaluating a Function Call, Could not find class ::mcollective_agent_bolt_tasks for vps238244.vittoria.pro (file: /etc/puppetlabs/code/environments/production/modules/mcollective/manifests/init.pp, line: 77, column: 3) on node vps238244.vittoria.pro',
                  },
                },
              },
              {
                program      => 'puppetserver',
                test_message => '2021-02-04T13:22:47.081-05:00 INFO  [qtp1102047314-255208] [puppetserver] Puppet Caching facts for desktop-8snl8la.lan',
                test_values  => {
                  '.puppetserver.severity'    => {
                    value => 'INFO',
                  },
                  '.puppetserver.thread_name' => {
                    value => 'qtp1102047314-255208',
                  },
                  '.puppetserver.timestamp'   => {
                    value => '2021-02-04T13:22:47.081-05:00',
                  },
                  'puppetserver.category'     => {
                    value => 'puppetserver',
                  },
                  'puppetserver.message'      => {
                    value => 'Puppet Caching facts for desktop-8snl8la.lan',
                  },
                },
              },
              {
                program      => 'puppetserver',
                test_message => '2021-02-04T13:55:42.518-05:00 WARN  [qtp1102047314-255768] [puppetserver] Scope(Class[Nginx::Package::Debian]) You must set $package_name to "nginx-extras" to enable Passenger',
                test_values  => {
                  '.puppetserver.severity'    => {
                    value => 'WARN',
                  },
                  '.puppetserver.thread_name' => {
                    value => 'qtp1102047314-255768',
                  },
                  '.puppetserver.timestamp'   => {
                    value => '2021-02-04T13:55:42.518-05:00',
                  },
                  'puppetserver.category'     => {
                    value => 'puppetserver',
                  },
                  'puppetserver.message'      => {
                    value => 'Scope(Class[Nginx::Package::Debian]) You must set $package_name to "nginx-extras" to enable Passenger',
                  },
                },
              },
            ],
          },
        ],
      }
      PUPPET
    end
  end

  Dir[File.join(__dir__, '..', '..', 'examples', 'OK_*.pp')].each do |f|
    example = File.basename(f)
    context "Example #{example}" do
      it_behaves_like 'the example', example
    end
  end

  Dir[File.join(__dir__, '..', '..', 'examples', 'NOK_*.pp')].each do |f|
    example = File.basename(f)
    context "Example #{example}" do
      it 'applies with errors' do
        apply_manifest(File.read(f), expect_failures: true)
      end
    end
  end
end
