# vim: tabstop=4 shiftwidth=4 softtabstop=4

define syslogng::pdb::simple::ruleset (
    $id,
    $patterns,
    $version        = 4,
    $pubdate,
    $description    = "generated by puppet",
    $url            = undef,
    $rules,
) {

    if ! defined(Class['Syslogng::Pdb']) {
        include syslogng::pdb
    }

    validate_array($patterns)
    validate_array($rules)
    validate_string($url)
    validate_string($description)
    validate_string($pub_date)
    validate_re($version, '^\d+$')
    validate_re($pubdate, '^\d+-\d+-\d+$')
    validate_string($provider)
    
    $pdb_file = "${syslogng::pdb::pdb_dir}/${name}.pdb"
    
    # validate rules
    syslogng_pdb_simple_rule ($rules)

	ensure_resource ( 'exec', 'update-patterndb',
		{ 
			command => "/usr/bin/pdbtool merge -r --glob \\*.pdb -D $::syslogng::pdb::pdb_dir -p ${::syslogng::temp_dir}/patterndb.xml",
			logoutput => true,
			refreshonly => true,
			notify      => Exec['deploy-patterndb']
		}
	)

	ensure_resource ( 'exec', 'deploy-patterndb',
		{ 
			command => "/bin/cp ${::syslogng::temp_dir}/patterndb.xml ${::syslogng::base_dir}/var/lib/syslog-ng/",
			#onlyif  => "/usr/bin/pdbtool --validate test ${::syslogng::temp_dir}/patterndb.xml",
			onlyif  => "/usr/bin/pdbtool test ${::syslogng::temp_dir}/patterndb.xml",
			logoutput => true,
			refreshonly => true
		}
	)

    file {$pdb_file:
        ensure      => present,
        #owner       => 'root',
        #group       => 'root',
        mode        => 0644,
        content     => template('syslogng/pdb/simple.pdb.erb'),
        notify      => Exec['update-patterndb']
    }
}
