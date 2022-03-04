# frozen_string_literal: true

# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # Needed for facter to fetch facts used by the apt module
  install_package(host, 'lsb-release') if fact_on(host, 'os.name') == 'Ubuntu'

  install_module_from_forge_on(host, 'ccin2p3/syslog_ng', '>= 0')
  install_module_from_forge_on(host, 'puppetlabs/apt', '>= 0')
  install_module_from_forge_on(host, 'puppet/epel', '>= 0')
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }